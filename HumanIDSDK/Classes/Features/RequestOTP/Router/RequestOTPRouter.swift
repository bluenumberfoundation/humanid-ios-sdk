internal protocol RequestOTPRoutingLogic {

    func pushLoginVC(with request: RequestOTP.Request)
    func popCurrentVC()
    func openTnc()
}

internal class RequestOTPRouter: RequestOTPRoutingLogic {

    weak var view: RequestOTPViewController?

    private var navVC: UINavigationController? { view?.navigationController }

    init(view: RequestOTPViewController) {
        self.view = view
    }

    func pushLoginVC(with request: RequestOTP.Request) {
        let loginVC = Injector.shared.resolver.resolve(LoginViewController.self)!
        loginVC.modalPresentationStyle = .overFullScreen
        loginVC.countryCode = request.countryCode
        loginVC.phoneNumber = request.phone
        loginVC.delegate = self.view

        view?.present(loginVC, animated: true)
    }

    func popCurrentVC() {
        navVC?.popViewController(animated: true)
    }

    func openTnc() {
        UIApplication.shared.open(.tnc)
    }
}
