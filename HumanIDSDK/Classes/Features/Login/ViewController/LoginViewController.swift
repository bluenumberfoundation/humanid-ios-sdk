import VKPinCodeView

internal protocol LoginDelegate {

    func login(with viewModel: Login.ViewModel)
}

internal class LoginViewController: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pinContainerView: UIView!
    @IBOutlet weak var humanIdTnc: UILabel!
    @IBOutlet weak var verificationInfo: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var containerViewBottom: NSLayoutConstraint!

    var viewModel: RequestOTP.ViewModel!

    var timer: Timer?
    var timerTap: UITapGestureRecognizer?

    var bottomSheetViewHeight: CGFloat = UIScreen.main.bounds.size.height * 0.40 {
        didSet {
            containerViewHeight.constant = bottomSheetViewHeight
            containerViewBottom.constant = bottomSheetViewHeight * -1.0
        }
    }

    var bottomSheetTouchPoint: CGPoint = CGPoint(x: 0, y: 0)

    var delegate: LoginDelegate?
    var input: LoginInteractorInput?
    var router: LoginRoutingLogic?

    lazy var pinView: VKPinCodeView = {
        let pinView = VKPinCodeView()
        pinView.translatesAutoresizingMaskIntoConstraints = false
        pinView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        pinView.onSettingStyle = { UnderlineStyle() }
        pinView.becomeFirstResponder()

        pinView.onComplete = { code, _ in
            self.login(verificationCode: code)
        }

        return pinView
    }()

    lazy var seconds: Int = {
        return viewModel.nextResendDelay
    }()

    convenience init() {
        self.init(nibName: "LoginViewController", bundle: Bundle.humanID)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        setupListener()
        setupTimer()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAnimation(isDismiss: false)
    }

    func configureViews() {
        view.backgroundColor = .clear

        bgView.alpha = 0.0
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        loadingView.isHidden = true

        pinContainerView.addSubview(pinView)
        pinView.leadingAnchor.constraint(equalTo: pinContainerView.leadingAnchor, constant: 40).isActive = true
        pinView.trailingAnchor.constraint(equalTo: pinContainerView.trailingAnchor, constant: -40).isActive = true
        pinView.centerYAnchor.constraint(equalTo: pinContainerView.centerYAnchor).isActive = true

        verificationInfo.text = "We just sent a text to (+\(viewModel.countryCode)) \(viewModel.phone). We will not save or forward this number after the verification"

        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func setupListener() {
        let tncTap = UITapGestureRecognizer(target: self, action: #selector(viewDidShowTnc))
        humanIdTnc.isUserInteractionEnabled = true
        humanIdTnc.addGestureRecognizer(tncTap)

        timerTap = UITapGestureRecognizer(target: self, action: #selector(viewDidResendCode))
    }

    func setupTimer() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }

    @IBAction func dismiss(_ sender: UITapGestureRecognizer) {
        showAnimation(isDismiss: true)
    }

    @IBAction func swipeDown(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: containerView.window)

        switch sender.state {
        case .began:
            bottomSheetTouchPoint = touchPoint
        case .ended, .cancelled:
            if touchPoint.y - bottomSheetTouchPoint.y > 100 {
                bgView.alpha = 0.0
                view.layoutIfNeeded()
                dismiss(animated: true)
            } else {
                UIView.animate(withDuration: 0.25) {
                    self.containerView.frame = CGRect(
                        x: 0,
                        y: touchPoint.y,
                        width: self.containerView.frame.size.width,
                        height: self.bottomSheetViewHeight - self.containerView.frame.size.height
                    )
                }
            }
        default:
            break
        }
    }

    @objc func viewDidShowTnc(_ sender: UITapGestureRecognizer) {
        router?.openTnc()
    }

    @objc func viewDidResendCode(_ sender: UITapGestureRecognizer) {
        pinView.resetCode()
        view.endEditing(true)

        let clientId = KeyChain.retrieves(key: .clientID) ?? ""
        let clientSecret = KeyChain.retrieves(key: .clientSecret) ?? ""
        let header = BaseRequest(clientId: clientId, clientSecret: clientSecret)

        input?.requestOtp(with: header, request: .init(
            countryCode: viewModel.countryCode,
            phone: viewModel.phone)
        )
    }

    @objc func updateTimer() {
        seconds -= 1

        switch seconds {
        case 0:
            invalidateTimer()
            resetTimerLabel()
        default:
            let timer = TimeInterval(seconds).toMinutesSeconds()
            timerLabel.text = "Resend code in \(timer)"
            timerLabel.isUserInteractionEnabled = false
            timerLabel.removeGestureRecognizer(timerTap!)
        }
    }

    @objc func showKeyboard(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardFrame = keyboardSize.cgRectValue
        let keyboardHeight = keyboardFrame.height

        containerViewBottom.constant = keyboardHeight - 40
    }

    @objc func hideKeyboard(notification: NSNotification) {
        containerViewBottom.constant = 0
    }

    private func login(verificationCode: String) {
        invalidateTimer()

        let clientId = KeyChain.retrieves(key: .clientID) ?? ""
        let clientSecret = KeyChain.retrieves(key: .clientSecret) ?? ""
        let header = BaseRequest(clientId: clientId, clientSecret: clientSecret)

        let deviceId = KeyChain.retrieves(key: .deviceID) ?? ""

        input?.login(with: header, request: .init(
            countryCode: viewModel.countryCode,
            phone: viewModel.phone,
            deviceTypeId: 2,
            deviceId: deviceId,
            verificationCode: verificationCode)
        )
    }

    private func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func resetTimerLabel() {
        timerLabel.text = "Resend code"
        timerLabel.isUserInteractionEnabled = true
        timerLabel.addGestureRecognizer(timerTap!)
    }

    private func resetView() {
        pinView.resetCode()
        pinView.becomeFirstResponder()
        containerViewBottom.constant = 50
    }

    private func showAnimation(isDismiss: Bool) {
        UIView.animate(withDuration: 0.25, animations: {
            self.bgView.alpha = isDismiss ? 0.0 : 0.3
            self.view.layoutIfNeeded()
        }) { (_) in
            if isDismiss {
                self.dismiss(animated: true)
            }
        }
    }
}

// MARK: - Presenter Delegate
extension LoginViewController: LoginPresenterOutput {

    func showLoading() {
        timerLabel.isHidden = true
        loadingView.isHidden = false
    }

    func hideLoading() {
        timerLabel.isHidden = false
        loadingView.isHidden = true
    }

    func successLogin(with viewModel: Login.ViewModel) {
        UIView.animate(withDuration: 0.25, animations: {
            self.bgView.alpha = 0.0
            self.view.layoutIfNeeded()
        }) { (_) in
            self.dismiss(animated: true) {
                self.delegate?.login(with: viewModel)
            }
        }
    }

    func successRequestOtp(with viewModel: RequestOTP.ViewModel) {
        seconds = viewModel.nextResendDelay
        setupTimer()
    }

    func errorLogin(with message: String) {
        alertVC(with: message) { _ in
            self.resetTimerLabel()
            self.resetView()
        }
    }

    func errorRequestOtp(with message: String) {
        alertVC(with: message) { _ in
            self.invalidateTimer()
            self.resetTimerLabel()
            self.resetView()
        }
    }
}
