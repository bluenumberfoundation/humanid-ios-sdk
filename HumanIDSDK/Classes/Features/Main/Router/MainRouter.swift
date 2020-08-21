internal protocol MainRouterProtocol: AnyObject {

    func goToRequestOtp(with appName: String, from target: UIViewController)
    func openTnc()
}

internal final class MainRouter: MainRouterProtocol {

    weak var controller: MainViewController?

    func goToRequestOtp(with appName: String, from target: UIViewController) {
        let controller = Injector.shared.resolve(RequestOTPViewController.self)!
        controller.modalPresentationStyle = .overCurrentContext
        controller.delegate = target as? RequestOTPDelegate
        controller.clientName = appName

        UIView.animate(withDuration: 0.25, animations: {
            self.controller?.bgView.alpha = 0.0
            self.controller?.view.layoutIfNeeded()
        }) { (_) in
            self.controller?.dismiss(animated: true) {
                target.present(controller, animated: true)
            }
        }
    }

    func openTnc() {
        UIApplication.shared.open(.tnc)
    }
}
