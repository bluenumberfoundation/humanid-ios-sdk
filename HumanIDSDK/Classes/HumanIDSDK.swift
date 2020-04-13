import Foundation

open class HumanIDSDK {

    public static let shared = HumanIDSDK()

    private init() {}

    open func config(appID: String, appSecret: String) {
        KeyChain.isStoreSuccess(key: .appIDKey, value: appID)
        KeyChain.isStoreSuccess(key: .appSecretKey, value: appSecret)
    }

    open func registerNotification(token: String) {
        KeyChain.isStoreSuccess(key: .notificationTokenKey, value: token)
    }

    open func getDeviceID() -> String {
        return KeyChain.retrieveString(key: .deviceID) ?? ""
    }

    open func setDeviceID(id: String) {
        KeyChain.isStoreSuccess(key: .deviceID, value: id)
    }

    open func verifyPhone(phoneNumber: String, countryCode: String, completion: @escaping (_ success: Bool, _ data: BaseResponse<DefaultResponse>) -> ()) {
        guard let appID = KeyChain.retrieveString(key: .appIDKey), let appSecret = KeyChain.retrieveString(key: .appSecretKey) else {
            completion(false, BaseResponse(message: "appID or appSecret not found", data: nil))
            return
        }

        let data = VerifyPhone(countryCode: countryCode, phone: phoneNumber, appId: appID, appSecret: appSecret)

        let jsonData = try? JSONEncoder().encode(data)
        Rest.post(url: .verifyPhone, data: jsonData, completion: {
            success, object, errormessage in

            guard let body = object, let response = try? JSONDecoder().decode(DefaultResponse.self, from: body) else {
                completion(success, BaseResponse(message: errormessage, data: nil))
                return
            }

            completion(success, BaseResponse(message: success.description, data: response))
        })
    }

    open func userRegistration(phoneNumber: String, countryCode: String, verificationCode: String, completion: @escaping (_ success: Bool, _ data: BaseResponse<DetailResponse>) -> ()) {
        guard
            let appID = KeyChain.retrieveString(key: .appIDKey),
            let appSecret = KeyChain.retrieveString(key: .appSecretKey) else {
                completion(false, BaseResponse(message: "appID or appSecret not found", data: nil))
                return
        }

        var notifID = ""
        if let token = KeyChain.retrieveString(key: .notificationTokenKey) {
            notifID = token
        }

        var deviceID = UUID().uuidString
        if let id = KeyChain.retrieveString(key: .deviceID) {
            deviceID = id
        } else {
            deviceID = "qwe23w12j3nj12b3j1b2nj3bj1b23jb1j2b3"
            //TODO: Generate deviceID try to communicate with humanid app
        }

        let data = UserRegistration(countryCode: countryCode, phone: phoneNumber, deviceId: deviceID, verificationCode: verificationCode, notifId: notifID, appId: appID, appSecret: appSecret)

        let jsonData = try? JSONEncoder().encode(data)
        Rest.post(url: .userRegistration, data: jsonData, completion: {
            success, object, errorMessage in

            guard let body = object, let response = try? JSONDecoder().decode(DetailResponse.self, from: body) else {
                completion(success, BaseResponse(message: errorMessage, data: nil))
                return
            }

            completion(success, BaseResponse(message: success.description, data: response))
        })

    }

    open func userLogin(hash: String, completion: @escaping (_ success: Bool, _ data: BaseResponse<DetailResponse>) -> ()) {
        guard
            let appID = KeyChain.retrieveString(key: .appIDKey),
            let appSecret = KeyChain.retrieveString(key: .appSecretKey) else {
                completion(false, BaseResponse(message: "appID or appSecret not found", data: nil))
                return
        }

        var notifID = ""
        if let token = KeyChain.retrieveString(key: .notificationTokenKey) {
            notifID = token
        }

        let data = UserLogin(existingHash: hash, notifId: notifID, appId: appID, appSecret: appSecret)

        let jsonData = try? JSONEncoder().encode(data)
        Rest.post(url: .userLogin, data: jsonData, completion: {
            success, object, errorMessage in

            guard let body = object, let response = try? JSONDecoder().decode(DetailResponse.self, from: body) else {
                completion(success, BaseResponse(message: errorMessage, data: nil))
                return
            }

            completion(success, BaseResponse(message: success.description, data: response))
        })
    }

    open func updateNotificationToken(token: String, completion: @escaping (_ success: Bool, _ data: BaseResponse<DetailResponse>) -> ()) {
        guard
            let appID = KeyChain.retrieveString(key: .appIDKey),
            let appSecret = KeyChain.retrieveString(key: .appSecretKey) else {
                completion(false, BaseResponse(message: "appID or appSecret not found", data: nil))
                return
        }

        let hash = KeyChain.retrieveString(key: .userHash) ?? ""

        let data = UserLogin(existingHash: hash, notifId: token, appId: appID, appSecret: appSecret)

        let jsonData = try? JSONEncoder().encode(data)
        Rest.put(url: .update, data: jsonData, completion: {
            success, object, errorMessage in

            guard let body = object, let response = try? JSONDecoder().decode(DetailResponse.self, from: body) else {
                completion(success, BaseResponse(message: errorMessage, data: nil))
                return
            }

            completion(success, BaseResponse(message: success.description, data: response))
        })
    }

    open func updatePhoneNumber(phoneNumber: String, countryCode: String, verificationCode: String, completion: @escaping (_ success: Bool, _ data: BaseResponse<DefaultResponse>) -> ()) {
        guard let appID = KeyChain.retrieveString(key: .appIDKey), let appSecret = KeyChain.retrieveString(key: .appSecretKey) else {
            completion(false, BaseResponse(message: "appID or appSecret not found", data: nil))
            return
        }

        let hash = KeyChain.retrieveString(key: .userHash) ?? ""

        let data = UpdatePhone(countryCode: countryCode, phone: phoneNumber, verificationCode: verificationCode, existingHash: hash, appId: appID, appSecret: appSecret)

        let jsonData = try? JSONEncoder().encode(data)
        Rest.post(url: .updatePhone, data: jsonData, completion: {
            success, object, errormessage in

            guard let body = object, let response = try? JSONDecoder().decode(DefaultResponse.self, from: body) else {
                completion(success, BaseResponse(message: errormessage, data: nil))
                return
            }

            completion(success, BaseResponse(message: success.description, data: response))
        })
    }

    open func confirmWebLogin(isAllowLogin: Bool, requestingAppId: String, completion: @escaping (_ success: Bool, _ data: BaseResponse<LoginConfirmationResponse>) -> ()) {
        guard let appID = KeyChain.retrieveString(key: .appIDKey), let appSecret = KeyChain.retrieveString(key: .appSecretKey) else {
            completion(false, BaseResponse(message: "appID or appSecret not found", data: nil))
            return
        }

        let hash = KeyChain.retrieveString(key: .userHash) ?? ""
        let confirmType = "WEB_LOGIN_REQUEST"

        let data = RejectLogin(hash: hash, requestingAppId: requestingAppId, type: confirmType, appId: appID, appSecret: appSecret)

        var urlRequest = URL.rejectLogin
        if isAllowLogin {
            urlRequest = URL.confirmLogin
        }

        let jsonData = try? JSONEncoder().encode(data)
        Rest.post(url: urlRequest, data: jsonData, completion: {
            success, object, errormessage in

            guard let body = object, let response = try? JSONDecoder().decode(LoginConfirmationResponse.self, from: body) else {
                completion(success, BaseResponse(message: errormessage, data: nil))
                return
            }

            completion(success, BaseResponse(message: success.description, data: response))
        })
    }

    open func loginCheck(completion: @escaping (_ success: Bool, _ data: BaseResponse<DefaultResponse>) -> ()) {
        guard let appID = KeyChain.retrieveString(key: .appIDKey), let appSecret = KeyChain.retrieveString(key: .appSecretKey) else {
            completion(false, BaseResponse(message: "appID or appSecret not found", data: nil))
            return
        }

        let hash = KeyChain.retrieveString(key: .userHash) ?? ""

        let data = LoginCheck(hash: hash, appId: appID, appSecret: appSecret)

        let jsonData = try? JSONEncoder().encode(data)
        Rest.get(url: .loginCheck, data: jsonData, completion: {
            success, object, errormessage in

            guard let body = object, let response = try? JSONDecoder().decode(DefaultResponse.self, from: body) else {
                completion(success, BaseResponse(message: errormessage, data: nil))
                return
            }

            completion(success, BaseResponse(message: success.description, data: response))
        })
    }

    open func getVerifyPhoneNumberViewController(clientImage: UIImage, clientName: String) -> UIViewController {
        return VerifyPhoneViewController(clientImage: clientImage, clientName: clientName)
    }

    open func getOTPViewController(otpType:OTPType, phoneNumber: String) -> UIViewController {
        return OTPViewController(otpType:otpType, phoneNumber: phoneNumber)
    }

    open func getEmailConfirmationViewController(email: String, clientName: String) -> UIViewController {
        return ConfirmEmailViewController(email: email, clientName: clientName)
    }

    open func getLoginViewController(clientName: String) -> UIViewController {
        return LoginViewController(clientName: clientName)
    }
}
