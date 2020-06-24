open class HumanIDSDK {

    public static let shared = HumanIDSDK()

    private init() {}

    open func configure(clientID: String, clientSecret: String) {
        _ = KeyChain.isStoreSuccess(key: .clientID, value: clientID)
        _ = KeyChain.isStoreSuccess(key: .clientSecret, value: clientSecret)

        // MARK: - Retrieve current deviceID automatically
        guard let _ = KeyChain.retrieves(key: .deviceID) else {
            let deviceID = UIDevice.current.identifierForVendor!.uuidString
            _ = KeyChain.isStoreSuccess(key: .deviceID, value: deviceID)

            return
        }
    }

    open func requestOtp(view viewController: UIViewController, name appName: String, image appImage: String) {
        // MARK: - Open humanID main page
        let mainVC = Injector.shared.resolver.resolve(MainViewController.self)!
        mainVC.modalPresentationStyle = .overFullScreen
        mainVC.clientName = appName
        mainVC.clientLogo = appImage
        mainVC.router?.parentVC = viewController

        viewController.present(mainVC, animated: true)
    }
}
