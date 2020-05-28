internal extension URL {

    static var base: URL {
        return URL(string: "https://core.human-id.org/v0.0.2/")!
    }

    static var tnc: URL {
        return URL(string: "https://www.human-id.org/privacypolicy")!
    }

    static var users: URL {
        return URL(string: "mobile/users/", relativeTo: base)!
    }

    static var requestOtp: URL {
        return URL(string: "login/request-otp", relativeTo: users)!
    }

    static var register: URL {
        return URL(string: "register", relativeTo: users)!
    }
}
