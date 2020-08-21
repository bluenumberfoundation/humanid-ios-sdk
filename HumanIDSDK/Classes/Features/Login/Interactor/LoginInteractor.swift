import RxSwift

internal protocol LoginInteractorInput: AnyObject {

    var disposeBag: DisposeBag? { get }

    func dispose()
    func login(with header: BaseRequest, and request: Login.Request)
    func requestOtp(with header: BaseRequest, and request: RequestOTP.Request)
}

internal protocol LoginInteractorOutput: AnyObject {

    func showLoading()
    func hideLoading()
    func successLogin(with response: BaseResponse<Login.Response>)
    func successRequestOtp(with request: RequestOTP.Request, and response: BaseResponse<RequestOTP.Response>)
    func errorLogin(with response: Error)
    func errorRequestOtp(with response: Error)
}

internal final class LoginInteractor: LoginInteractorInput {

    var output: LoginInteractorOutput!
    var worker: LoginWorkerProtocol!

    var disposeBag: DisposeBag?

    func dispose() {
        disposeBag = nil
    }

    func login(with header: BaseRequest, and request: Login.Request) {
        output.showLoading()
        worker.login(with: header, and: request)
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: {[weak self] (response) in
                    self?.output.hideLoading()
                    self?.output.successLogin(with: response)
                },
                onError: {[weak self] (error) in
                    self?.output.hideLoading()
                    self?.output.errorLogin(with: error)
            }).disposed(by: disposeBag!)
    }

    func requestOtp(with header: BaseRequest, and request: RequestOTP.Request) {
        output.showLoading()
        worker.requestOtp(with: header, and: request)
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: {[weak self] (response) in
                    self?.output.hideLoading()
                    self?.output.successRequestOtp(with: request, and: response)
                },
                onError: {[weak self] (error) in
                    self?.output.hideLoading()
                    self?.output.errorRequestOtp(with: error)
            }).disposed(by: disposeBag!)
    }
}
