import RxSwift

internal protocol LoginWorkerDelegate {

    func login(with header: BaseRequest, request: Login.Request) -> Observable<BaseResponse<Login.Response>>
    func requestOtp(with header: BaseRequest, request: RequestOTP.Request) -> Observable<BaseResponse<RequestOTP.Response>>
}

internal class LoginWorker: LoginWorkerDelegate {

    var datasource: Network

    init(datasource: Network) {
        self.datasource = datasource
    }

    func login(with header: BaseRequest, request: Login.Request) -> Observable<BaseResponse<Login.Response>> {
        return datasource.login(url: .login, header: header, request: request)
    }

    func requestOtp(with header: BaseRequest, request: RequestOTP.Request) -> Observable<BaseResponse<RequestOTP.Response>> {
        return datasource.requestOtp(url: .requestOtp, header: header, request: request)
    }
}
