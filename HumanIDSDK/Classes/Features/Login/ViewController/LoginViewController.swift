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

    var timer: Timer?
    var timerTap: UITapGestureRecognizer?

    var countryCode = ""
    var phoneNumber = ""
    var seconds = 30

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
    var requestOtp: RequestOTP.Request?
    var requestLogin: Login.Request?

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
        self.view.backgroundColor = .clear

        bgView.alpha = 0.0
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        loadingView.isHidden = true

        pinContainerView.addSubview(pinView)
        pinView.leadingAnchor.constraint(equalTo: pinContainerView.leadingAnchor, constant: 40).isActive = true
        pinView.trailingAnchor.constraint(equalTo: pinContainerView.trailingAnchor, constant: -40).isActive = true
        pinView.centerYAnchor.constraint(equalTo: pinContainerView.centerYAnchor).isActive = true

        verificationInfo.text = "We just sent a text to (+\(countryCode)) \(phoneNumber). We will not save or forward this number after the verification"
    }

    func setupListener() {
        let tncTap = UITapGestureRecognizer(target: self, action: #selector(self.viewDidShowTnc(_ :)))
        humanIdTnc.isUserInteractionEnabled = true
        humanIdTnc.addGestureRecognizer(tncTap)

        timerTap = UITapGestureRecognizer(target: self, action: #selector(self.viewDidResendCode(_:)))
    }

    func setupTimer() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
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
                self.bgView.alpha = 0.0
                self.view.layoutIfNeeded()
                self.dismiss(animated: true)
            } else {
                UIView.animate(withDuration: 0.25, animations: {
                    self.containerView.frame = CGRect(
                        x: 0,
                        y: touchPoint.y,
                        width: self.containerView.frame.size.width,
                        height: self.bottomSheetViewHeight - self.containerView.frame.size.height
                    )
                })
            }
        default:
            break
        }
    }

    @objc func viewDidShowTnc(_ sender: UITapGestureRecognizer) {
        router?.openTnc()
    }

    @objc func viewDidResendCode(_ sender: UITapGestureRecognizer) {
        seconds = 30
        setupTimer()
        pinView.resetCode()

        let clientId = KeyChain.retrieves(key: .clientID) ?? ""
        let clientSecret = KeyChain.retrieves(key: .clientSecret) ?? ""
        let header = BaseRequest(clientId: clientId, clientSecret: clientSecret)

        self.requestOtp = .init(countryCode: countryCode, phone: phoneNumber)
        input?.requestOtp(with: header, request: requestOtp!)
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

    private func login(verificationCode: String) {
        invalidateTimer()

        let clientId = KeyChain.retrieves(key: .clientID) ?? ""
        let clientSecret = KeyChain.retrieves(key: .clientSecret) ?? ""
        let header = BaseRequest(clientId: clientId, clientSecret: clientSecret)

        let deviceId = KeyChain.retrieves(key: .deviceID) ?? ""

        self.requestLogin = .init(
            countryCode: self.countryCode,
            phone: self.phoneNumber,
            deviceId: deviceId,
            verificationCode: verificationCode
        )
        input?.login(with: header, request: self.requestLogin!)
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

    private func showAnimation(isDismiss: Bool) {
        containerViewBottom.constant = isDismiss ? (bottomSheetViewHeight * -1.0) : 0.0

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

    func successRequestOtp() {
        pinView.becomeFirstResponder()
    }

    func errorLogin(with message: String) {
        alertVC(with: message, completion: { _ in
            self.pinView.resetCode()
            self.resetTimerLabel()
        })
    }

    func errorRequestOtp(with message: String) {
        alertVC(with: message, completion: { _ in
            self.invalidateTimer()
            self.resetTimerLabel()
        })
    }
}
