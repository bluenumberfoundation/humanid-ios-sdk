import Foundation

public struct BaseResponse<T: Codable>: Codable {

    let message: String?
    let data: T?
}

public struct DefaultResponse: Codable {

    let message: String
}

public struct DetailResponse: Codable {

    let appId: String
    let hash: String
    let deviceId: String
    let notifId: String?
}

public struct LoginConfirmationResponse: Codable {

    let id: String?
    let appId: String?
    let type: String?
    let confirmingAppId: String?
    let status: String?
}
