internal protocol RequestOTPRoutingLogic {

    func pushLoginVC(with viewModel: RequestOTP.ViewModel)
    func openTnc()
}

internal class RequestOTPRouter: RequestOTPRoutingLogic {

    weak var view: RequestOTPViewController?

    init(view: RequestOTPViewController) {
        self.view = view
    }

    func pushLoginVC(with viewModel: RequestOTP.ViewModel) {
        let loginVC = Injector.shared.resolver.resolve(LoginViewController.self)!
        loginVC.modalPresentationStyle = .overFullScreen
        loginVC.delegate = view
        loginVC.viewModel = viewModel

        view?.present(loginVC, animated: true)
    }

    func openTnc() {
        UIApplication.shared.open(.tnc)
    }
}
