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

    open func requestOtp(from target: UIViewController, name appName: String, image appImage: String) {
        // MARK: - Open humanID main page
        let controller = Injector.shared.resolve(MainViewController.self)!
        controller.modalPresentationStyle = .overFullScreen
        controller.root = target
        controller.clientName = appName
        controller.clientLogo = appImage

        target.present(controller, animated: true)
    }
}
