import RxSwift

internal protocol LoginInteractorInput {

    func login(with header: BaseRequest, request: Login.Request)
    func requestOtp(with header: BaseRequest, request: RequestOTP.Request)
}

internal protocol LoginInteractorOutput {

    func showLoading()
    func hideLoading()
    func successLogin(with response: BaseResponse<Login.Response>)
    func successRequestOtp(with response: BaseResponse<RequestOTP.Response>)
    func errorLogin(with errorResponse: Error)
    func errorRequestOtp(with errorResponse: Error)
}

internal class LoginInteractor: LoginInteractorInput {

    var output: LoginInteractorOutput?
    var worker: LoginWorkerDelegate?

    private let disposeBag = DisposeBag()

    init(output: LoginInteractorOutput, worker: LoginWorkerDelegate) {
        self.output = output
        self.worker = worker
    }

    func login(with header: BaseRequest, request: Login.Request) {
        output?.showLoading()
        worker?.login(with: header, request: request)
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: {[weak self] (response) in
                    self?.output?.hideLoading()
                    self?.output?.successLogin(with: response)
                },
                onError: {[weak self] (error) in
                    self?.output?.hideLoading()
                    self?.output?.errorLogin(with: error)
            }).disposed(by: disposeBag)
    }

    func requestOtp(with header: BaseRequest, request: RequestOTP.Request) {
        output?.showLoading()
        worker?.requestOtp(with: header, request: request)
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: {[weak self] (response) in
                    self?.output?.hideLoading()
                    self?.output?.successRequestOtp(with: response)
                },
                onError: {[weak self] (error) in
                    self?.output?.hideLoading()
                    self?.output?.errorRequestOtp(with: error)
            }).disposed(by: disposeBag)
    }
}
