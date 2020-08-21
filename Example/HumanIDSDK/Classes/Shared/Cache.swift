import Foundation

final class Cache {

    static let shared = Cache()

    private let defaults: UserDefaults

    let token = "token"

    private init() {
        self.defaults = UserDefaults.standard
    }

    func getToken() -> String? {
        return defaults.string(forKey: token)
    }

    func setToken(with value: String) {
        defaults.set(value, forKey: token)
    }

    func clear() {
        defaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        defaults.synchronize()
    }
}
