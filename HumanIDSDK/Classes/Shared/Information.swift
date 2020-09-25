internal enum InformationKey: String {
    case base = "BaseLink"
    case sandbox = "SandboxLink"
    case web = "Web"
}

internal struct Information {

    static func key(_ key: InformationKey) -> String {
        return Information.dict[key.rawValue] as! String
    }

    private static var dict: [String: Any] {
        guard let dict = Bundle.humanID.infoDictionary else { fatalError("Info.plist key not found!") }
        return dict
    }
}
