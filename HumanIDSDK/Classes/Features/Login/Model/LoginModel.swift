internal struct Login {

    struct Request: Codable {

        let countryCode: String
        let phone: String
        let deviceTypeId: Int
        let deviceId: String
        let verificationCode: String
    }

    struct Response: Codable {

        let exchangeToken: String?
    }

    struct ViewModel {

        let token: String
    }
}
