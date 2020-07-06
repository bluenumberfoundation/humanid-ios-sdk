import FlagPhoneNumber
import RxSwift
import RxCocoa

public protocol RequestOTPDelegate {

    func login(with token: String)
}

internal class RequestOTPViewController: UIViewController {

    @IBOutlet weak var phoneContainerView: UIView!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var verifyLabel: UILabel!
    @IBOutlet weak var verifyTnc: UILabel!
    @IBOutlet weak var cancelLabel: UIButton!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!

    var listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)

    var clientName = ""

    var delegate: RequestOTPDelegate?
    var input: RequestOTPInteractorInput?
    var router: RequestOTPRoutingLogic?

    lazy var phoneNumberTextField: FPNTextField = {
        let phoneNumberTextField = FPNTextField(frame: CGRect(x: 0, y: 0, width: phoneContainerView.bounds.width - 16, height: 30))
        phoneNumberTextField.font = UIFont.font(type: .titiliumWebRegular, size: 14)
        phoneNumberTextField.textColor = .white
        phoneNumberTextField.displayMode = .list
        phoneNumberTextField.delegate = self
        phoneNumberTextField.tintColor = .white
        phoneNumberTextField.becomeFirstResponder()

        guard let regionCode = Locale.current.regionCode else { return phoneNumberTextField }
        phoneNumberTextField.setFlag(countryCode: FPNCountryCode(rawValue: regionCode) ?? .US)

        return phoneNumberTextField
    }()

    private let disposeBag = DisposeBag()

    convenience init() {
        self.init(nibName: "RequestOTPViewController", bundle: Bundle.humanID)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        setupListener()
        setupFormValidation()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    func configureViews() {
        view.backgroundColor = .twilightBlue

        loadingView.isHidden = true

        phoneNumberTextField.placeholder = "Enter Phone Number"
        phoneNumberTextField.attributedPlaceholder = NSAttributedString(string: phoneNumberTextField.placeholder ?? "", attributes: [.foregroundColor: UIColor.gray])

        listController.setup(repository: phoneNumberTextField.countryRepository)
        listController.didSelect = { [weak self] country in
            self?.phoneNumberTextField.setFlag(countryCode: country.code)
        }

        phoneContainerView.addSubview(phoneNumberTextField)

        enterButton.backgroundColor = .lightMusrad
        enterButton.tintColor = .twilightBlue
        enterButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)

        let verifyText = "humanID confirms your phone number "
        let verifyString = NSMutableAttributedString(string: verifyText)

        let verifyTextClient = " sharing it with "
        let verifyStringClient = NSMutableAttributedString(string: verifyTextClient)

        let verifyBoldText = "without"
        let verifyAttrs = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)]
        let verifyAttributed = NSMutableAttributedString(string: verifyBoldText, attributes: verifyAttrs)
        let verifyClientAttributed = NSMutableAttributedString(string: clientName, attributes: verifyAttrs)

        verifyString.append(verifyAttributed)
        verifyStringClient.append(verifyClientAttributed)

        let verifyAllString = NSMutableAttributedString()
        verifyAllString.append(verifyString)
        verifyAllString.append(verifyStringClient)
        verifyAllString.append(NSMutableAttributedString(string: ".\nYour data is permanently deleted after verification."))

        verifyLabel.attributedText = verifyAllString

        let tncText = "humanID gives you back control over your privacy. The non profit organization authenticates you without sharing your data or retaining your data.\n"
        let tncString = NSMutableAttributedString(string: tncText)

        let tncBoldText = "Learn More"
        let tncAttrs = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10)]
        let tncAttributed = NSMutableAttributedString(string: tncBoldText, attributes: tncAttrs)

        tncString.append(tncAttributed)

        verifyTnc.attributedText = tncString
    }

    func setupListener() {
        let tncTap = UITapGestureRecognizer(target: self, action: #selector(viewDidShowTnc))
        verifyTnc.isUserInteractionEnabled = true
        verifyTnc.addGestureRecognizer(tncTap)
    }

    func setupFormValidation() {
        let phoneValid: Observable<Bool> = phoneNumberTextField.rx.text
            .map { text -> Bool in
                let isPhoneValid = text!.count >= 1
                self.setButtonAlpha(isValid: isPhoneValid)

                return isPhoneValid
        }
        .share(replay: 1)
        .distinctUntilChanged()
        phoneValid.bind(to: enterButton.rx.isEnabled).disposed(by: disposeBag)
    }

    @IBAction func showOTPModal(_ sender: Any) {
        guard
            let countryCode = phoneNumberTextField.selectedCountry?.phoneCode.replacingOccurrences(of: "+", with: ""),
            let phone = phoneNumberTextField.getRawPhoneNumber() else { return }

        let clientId = KeyChain.retrieves(key: .clientID) ?? ""
        let clientSecret = KeyChain.retrieves(key: .clientSecret) ?? ""
        let header = BaseRequest(clientId: clientId, clientSecret: clientSecret)

        input?.requestOtp(with: header, request: .init(
            countryCode: countryCode,
            phone: phone)
        )
    }

    @IBAction func viewDidDismiss(_ sender: Any) {
        dismiss(animated: true)
    }

    @objc func viewDidShowTnc(_ sender: UITapGestureRecognizer) {
        router?.openTnc()
    }

    private func setButtonAlpha(isValid: Bool) {
        if !isValid {
            enterButton.alpha = 0.5
        } else {
            enterButton.alpha = 1.0
        }
    }
}

// MARK: - Presenter Delegate
extension RequestOTPViewController: RequestOTPPresenterOutput {

    func showLoading() {
        view.endEditing(true)
        enterButton.isEnabled = false
        cancelLabel.isHidden = true
        loadingView.isHidden = false
        setButtonAlpha(isValid: false)
    }

    func hideLoading() {
        enterButton.isEnabled = true
        cancelLabel.isHidden = false
        loadingView.isHidden = true
        setButtonAlpha(isValid: true)
    }

    func success(with viewModel: RequestOTP.ViewModel) {
        router?.pushLoginVC(with: viewModel)
    }

    func error(with message: String) {
        alertVC(with: message) { _ in
            self.phoneNumberTextField.becomeFirstResponder()
            self.phoneNumberTextField.text = ""
            self.setupFormValidation()
        }
    }
}

// MARK: - FlagPhoneNumber Delegate
extension RequestOTPViewController: FPNTextFieldDelegate {

    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {}
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {}

    func fpnDisplayCountryList() {
        let navVC = UINavigationController(rootViewController: listController)
        listController.title = "Countries"

        present(navVC, animated: true) {
            DispatchQueue.main.async {
                self.listController.searchController.searchBar.becomeFirstResponder()
            }
        }
    }
}

// MARK: - Login Delegate
extension RequestOTPViewController: LoginDelegate {

    func login(with viewModel: Login.ViewModel) {
        dismiss(animated: true) {
            self.delegate?.login(with: viewModel.token)
        }
    }
}
