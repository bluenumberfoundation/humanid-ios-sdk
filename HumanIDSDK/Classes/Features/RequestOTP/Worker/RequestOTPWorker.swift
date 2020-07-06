import RxSwift

internal protocol RequestOTPWorkerDelegate {

    func requestOtp(with header: BaseRequest, request: RequestOTP.Request) -> Observable<BaseResponse<RequestOTP.Response>>
}

internal class RequestOTPWorker: RequestOTPWorkerDelegate {

    var datasource: Network

    init(datasource: Network) {
        self.datasource = datasource
    }

    func requestOtp(with header: BaseRequest, request: RequestOTP.Request) -> Observable<BaseResponse<RequestOTP.Response>> {
        return datasource.requestOtp(url: .requestOtp, header: header, request: request)
    }
}
