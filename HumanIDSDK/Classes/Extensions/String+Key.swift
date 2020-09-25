internal extension String {

    static var clientID: String {
        return "client_id"
    }

    static var clientSecret: String {
        return "client_secret"
    }

    static var deviceID: String {
        return "device_id"
    }

    func localized() -> String {
        return NSLocalizedString(self, bundle: Bundle.humanID, comment: "")
    }
}
