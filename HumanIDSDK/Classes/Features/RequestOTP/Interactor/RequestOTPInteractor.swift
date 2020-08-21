import RxSwift

internal protocol RequestOTPInteractorInput: AnyObject {

    var disposeBag: DisposeBag? { get }

    func dispose()
    func requestOtp(with header: BaseRequest, and request: RequestOTP.Request)
}

internal protocol RequestOTPInteractorOutput: AnyObject {

    func showLoading()
    func hideLoading()
    func success(with request: RequestOTP.Request, and response: BaseResponse<RequestOTP.Response>)
    func error(with response: Error)
}

internal final class RequestOTPInteractor: RequestOTPInteractorInput {

    var output: RequestOTPInteractorOutput!
    var worker: RequestOTPWorkerProtocol!

    var disposeBag: DisposeBag?

    func dispose() {
        disposeBag = nil
    }

    func requestOtp(with header: BaseRequest, and request: RequestOTP.Request) {
        output.showLoading()
        worker.requestOtp(with: header, and: request)
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: {[weak self] (response) in
                    self?.output.hideLoading()
                    self?.output.success(with: request, and: response)
                },
                onError: {[weak self] (error) in
                    self?.output.hideLoading()
                    self?.output.error(with: error)
            }).disposed(by: disposeBag!)
    }
}
