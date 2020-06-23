internal protocol MainRoutingLogic {

    func pushRequestOtpVC(with appName: String)
    func openTnc()
}

internal class MainRouter: MainRoutingLogic {

    weak var view: MainViewController?

    init(view: MainViewController) {
        self.view = view
    }

    func pushRequestOtpVC(with appName: String) {
        // TODO Not yet implemented
    }

    func openTnc() {
        UIApplication.shared.open(.tnc)
    }
}
