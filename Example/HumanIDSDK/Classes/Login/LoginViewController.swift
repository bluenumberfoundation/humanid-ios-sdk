import UIKit
import HumanIDSDK

class LoginViewController: UIViewController {

    @IBOutlet weak var btnLogin: UIButton!

    private let displayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
    private let applicationLogo = "Logo"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = displayName

        btnLogin.layer.cornerRadius = 8
        btnLogin.clipsToBounds = true
    }

    @IBAction func didLogin(_ sender: Any) {
        HumanIDSDK.shared.requestOtp(view: self, name: displayName, image: applicationLogo)
    }
}

extension LoginViewController: RequestOTPDelegate {

    func login(with token: String) {
        guard let window = UIApplication.shared.keyWindow else { return }
        Cache.shared.setToken(with: token)

        let rootVC = HomeViewController()
        let navVC = UINavigationController(rootViewController: rootVC)
        window.rootViewController = navVC
    }
}
