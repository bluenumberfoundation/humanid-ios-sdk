import UIKit
import HumanIDSDK

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // MARK: - Retrieve HumanIDSDK appID and appSecret
        let clientID = "MOBILE_m65nshUmT9BDchwFEKdz"
        let clientSecret = "12FZ3llRg5KFDuJFLftOxlQof1DKBtgL7mZrY4AE1zaM78o1Fvza2IZdKjdxT45Q"
        HumanIDSDK.shared.configure(clientID: clientID, clientSecret: clientSecret)

        let contoller = UINavigationController(rootViewController: getController())
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = contoller
        window?.makeKeyAndVisible()

        return true
    }

    private func getController() -> UIViewController {
        return Cache.shared.getToken() != nil ? HomeViewController() : LoginViewController()
    }
}
