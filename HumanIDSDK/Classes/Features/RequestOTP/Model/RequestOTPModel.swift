internal struct RequestOTP {

    struct Request: Codable {

        let countryCode: String
        let phone: String
    }

    struct Response: Codable {

        let requestId: String?
        let nextResendAt: Int64?
        let failAttemptCount: Int?
        let otpCount: Int?
        let config: Config?

        struct Config: Codable {

            let otpSessionLifetime: Int64?
            let otpCountLimit: Int?
            let failAttemptLimit: Int?
            let nextResendDelay: Int64?
            let otpCodeLength: Int?
        }
    }

    struct ViewModel {

        let requestId: String
        let nextResendAt: Int64
        let failAttemptCount: Int
        let otpCount: Int
        let otpSessionLifetime: Int64
        let otpCountLimit: Int
        let failAttemptLimit: Int
        let nextResendDelay: Int64
        let otpCodeLength: Int
    }
}
