internal protocol LoginPresenterOutput: AnyObject {

    func showLoading()
    func hideLoading()
    func successLogin(with viewModel: Login.ViewModel)
    func successRequestOtp(with viewModel: RequestOTP.ViewModel)
    func errorLogin(with message: String)
    func errorRequestOtp(with message: String)
}

internal final class LoginPresenter: LoginInteractorOutput {

    var output: LoginPresenterOutput!

    func showLoading() {
        output.showLoading()
    }

    func hideLoading() {
        output.hideLoading()
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
            output.successLogin(with: viewModel)
        default:
            output.errorLogin(with: message)
        }
    }

    func successRequestOtp(with request: RequestOTP.Request, and response: BaseResponse<RequestOTP.Response>) {
        guard
            let isSuccess = response.success,
            let message = response.message else {
                return
        }

        switch isSuccess {
        case true:
            guard
                let data = response.data,
                let requestId = data.requestId,
                let nextResendAt = data.nextResendAt,
                let failAttemptCount = data.failAttemptCount,
                let otpCount = data.otpCount,
                let config = data.config,
                let otpSessionLifetime = config.otpSessionLifetime,
                let otpCountLimit = config.otpCountLimit,
                let failAttemptLimit = config.failAttemptLimit,
                let nextResendDelay = config.nextResendDelay,
                let otpCodeLength = config.otpCodeLength else { return }

            let viewModel = RequestOTP.ViewModel(
                countryCode: request.countryCode,
                phone: request.phone,
                requestId: requestId,
                nextResendAt: nextResendAt,
                failAttemptCount: failAttemptCount,
                otpCount: otpCount,
                otpSessionLifetime: otpSessionLifetime,
                otpCountLimit: otpCountLimit,
                failAttemptLimit: failAttemptLimit,
                nextResendDelay: nextResendDelay,
                otpCodeLength: otpCodeLength
            )
            output.successRequestOtp(with: viewModel)
        default:
            output.errorRequestOtp(with: message)
        }
    }

    func errorLogin(with response: Error) {
        output.errorLogin(with: response.localizedDescription)
    }

    func errorRequestOtp(with response: Error) {
        output.errorRequestOtp(with: response.localizedDescription)
    }
}
