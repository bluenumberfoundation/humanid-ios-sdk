internal protocol MainRoutingLogic {

    var parentVC: UIViewController? { get set }

    func pushRequestOtpVC(with appName: String)
    func openTnc()
}

internal class MainRouter: MainRoutingLogic {

    weak var parentVC: UIViewController?
    weak var view: MainViewController?

    private var navVC: UINavigationController? { parentVC?.navigationController }

    init(view: MainViewController) {
        self.view = view
    }

    func pushRequestOtpVC(with appName: String) {
        let requestOtpVC = Injector.shared.resolver.resolve(RequestOTPViewController.self)!
        requestOtpVC.clientName = appName
        requestOtpVC.delegate = parentVC as? RequestOTPDelegate

        UIView.animate(withDuration: 0.25, animations: {
            self.view?.bgView.alpha = 0.0
            self.view?.view.layoutIfNeeded()
        }) { (_) in
            self.view?.dismiss(animated: true) {
                self.navVC?.pushViewController(requestOtpVC, animated: true)
            }
        }
    }

    func openTnc() {
        UIApplication.shared.open(.tnc)
    }
}
