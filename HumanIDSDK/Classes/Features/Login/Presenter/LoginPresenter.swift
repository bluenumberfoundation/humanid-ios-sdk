internal protocol LoginPresenterOutput: class {

    func showLoading()
    func hideLoading()
    func successLogin(with viewModel: Login.ViewModel)
    func errorLogin(with message: String)
    func errorRequestOtp(with message: String)
}

internal class LoginPresenter: LoginInteractorOutput {

    weak var output: LoginPresenterOutput?

    init(output: LoginPresenterOutput) {
        self.output = output
    }

    func showLoading() {
        output?.showLoading()
    }

    func hideLoading() {
        output?.hideLoading()
    }

    func successLogin(with response: BaseResponse<Login.Response>) {
        guard
            let isSuccess = response.success,
            let message = response.message else {
                return
        }

        switch isSuccess {
        case true:
            guard
                let data = response.data,
                let token = data.exchangeToken else { return }

            let viewModel = Login.ViewModel(token: token)
            output?.successLogin(with: viewModel)
        default:
            output?.errorLogin(with: message)
        }
    }

    func successRequestOtp(with response: BaseResponse<NetworkResponse>) {
        guard
            let isSuccess = response.success,
            let message = response.message else {
                return
        }

        switch isSuccess {
        case false:
            output?.errorRequestOtp(with: message)
        default:
            break
        }
    }

    func errorLogin(with errorResponse: Error) {
        output?.errorLogin(with: errorResponse.localizedDescription)
    }

    func errorRequestOtp(with errorResponse: Error) {
        output?.errorRequestOtp(with: errorResponse.localizedDescription)
    }
}
