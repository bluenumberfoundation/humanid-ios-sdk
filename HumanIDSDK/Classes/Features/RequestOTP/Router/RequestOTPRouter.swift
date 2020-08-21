internal protocol RequestOTPRouterProtocol: AnyObject {

    func goToLogin(with viewModel: RequestOTP.ViewModel)
    func openTnc()
}

internal final class RequestOTPRouter: RequestOTPRouterProtocol {

    weak var controller: RequestOTPViewController?

    func goToLogin(with viewModel: RequestOTP.ViewModel) {
        let controller = Injector.shared.resolve(LoginViewController.self)!
        controller.modalPresentationStyle = .overFullScreen
        controller.delegate = self.controller
        controller.viewModel = viewModel

        self.controller?.present(controller, animated: true)
    }

    func openTnc() {
        UIApplication.shared.open(.tnc)
    }
}
