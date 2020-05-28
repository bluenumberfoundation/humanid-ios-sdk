import RxSwift

internal protocol RequestOTPInteractorInput {

    func requestOtp(with request: RequestOTP.Request)
}

internal protocol RequestOTPInteractorOutput {

    func showLoading()
    func hideLoading()
    func success(with response: BaseResponse<NetworkResponse>)
    func error(with errorResponse: Error)
}

internal class RequestOTPInteractor: RequestOTPInteractorInput {

    var output: RequestOTPInteractorOutput?
    var worker: RequestOTPWorkerDelegate?

    private let disposeBag = DisposeBag()

    init(output: RequestOTPInteractorOutput, worker: RequestOTPWorkerDelegate) {
        self.output = output
        self.worker = worker
    }

    func requestOtp(with request: RequestOTP.Request) {
        output?.showLoading()
        worker?.requestOtp(with: request)
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: {[weak self] (response) in
                    self?.output?.hideLoading()
                    self?.output?.success(with: response)
                },
                onError: {[weak self] (error) in
                    self?.output?.hideLoading()
                    self?.output?.error(with: error)
            }).disposed(by: disposeBag)
    }
}
