open class HumanIDSDK {

    public static let shared = HumanIDSDK()

    private init() {}

    open func configure(appID: String, appSecret: String) {
        _ = KeyChain.isStoreSuccess(key: .appIDKey, value: appID)
        _ = KeyChain.isStoreSuccess(key: .appSecretKey, value: appSecret)

        // MARK: - Retrieve current deviceID automatically
        guard let _ = KeyChain.retrieveString(key: .deviceID) else {
            let deviceID = UIDevice.current.identifierForVendor!.uuidString
            _ = KeyChain.isStoreSuccess(key: .deviceID, value: deviceID)

            return
        }
    }

    open func verify(view viewController: UIViewController, name appName: String, image appImage: String) {
        // MARK: - Open humanID verification page
        let verifyVC = Injector.shared.resolver.resolve(VerifyViewController.self)!
        verifyVC.appName = appName
        verifyVC.appImage = appImage
        verifyVC.delegate = viewController as? VerifyDelegate

        viewController.present(verifyVC, animated: true)
    }

    open func revoke() {
        // MARK: - Revoke humanID sdk access
        guard
            let appId = KeyChain.retrieveString(key: .appIDKey),
            let appSecret = KeyChain.retrieveString(key: .appSecretKey),
            let deviceHash = KeyChain.retrieveString(key: .deviceHash) else {
                return
        }

        let input = Injector.shared.resolver.resolve(RevokeInteractorInput.self)!
        input.revoke(with: .init(appId: appId, appSecret: appSecret, userHash: deviceHash))
    }
}
