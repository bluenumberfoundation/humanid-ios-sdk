internal extension URL {

    static var base: URL {
        let path = HumanIDSDK.isSandbox ? Information.key(.sandbox) : Information.key(.base)
        return URL(string: path)!
    }

    static var tnc: URL {
        return URL(string: Information.key(.web))!
    }

    static var users: URL {
        return URL(string: "mobile/users/", relativeTo: base)!
    }

    static var requestOtp: URL {
        return URL(string: "login/request-otp", relativeTo: users)!
    }

    static var login: URL {
        return URL(string: "login", relativeTo: users)!
    }
}
