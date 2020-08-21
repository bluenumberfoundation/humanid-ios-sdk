import RxSwift

internal protocol RequestOTPWorkerProtocol: AnyObject {

    func requestOtp(with header: BaseRequest, and request: RequestOTP.Request) -> Observable<BaseResponse<RequestOTP.Response>>
}

internal final class RequestOTPWorker: RequestOTPWorkerProtocol {

    var datasource: Network!

    func requestOtp(with header: BaseRequest, and request: RequestOTP.Request) -> Observable<BaseResponse<RequestOTP.Response>> {
        return datasource.requestOtp(url: .requestOtp, header: header, request: request)
    }
}
