internal protocol LoginRouterProtocol: AnyObject {

    func openTnc()
}

internal final class LoginRouter: LoginRouterProtocol {

    func openTnc() {
        UIApplication.shared.open(.tnc)
    }
}
