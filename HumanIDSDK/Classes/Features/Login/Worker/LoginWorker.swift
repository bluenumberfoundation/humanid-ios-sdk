import RxSwift

internal protocol LoginWorkerProtocol: AnyObject {

    func login(with header: BaseRequest, and request: Login.Request) -> Observable<BaseResponse<Login.Response>>
    func requestOtp(with header: BaseRequest, and request: RequestOTP.Request) -> Observable<BaseResponse<RequestOTP.Response>>
}

internal final class LoginWorker: LoginWorkerProtocol {

    var datasource: Network!

    func login(with header: BaseRequest, and request: Login.Request) -> Observable<BaseResponse<Login.Response>> {
        return datasource.login(url: .login, header: header, request: request)
    }

    func requestOtp(with header: BaseRequest, and request: RequestOTP.Request) -> Observable<BaseResponse<RequestOTP.Response>> {
        return datasource.requestOtp(url: .requestOtp, header: header, request: request)
    }
}
