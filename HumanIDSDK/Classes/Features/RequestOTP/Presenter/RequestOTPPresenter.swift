internal protocol RequestOTPPresenterOutput: class {

    func showLoading()
    func hideLoading()
    func success(with viewModel: RequestOTP.ViewModel)
    func error(with message: String)
}

internal class RequestOTPPresenter: RequestOTPInteractorOutput {

    weak var output: RequestOTPPresenterOutput?

    init(output: RequestOTPPresenterOutput) {
        self.output = output
    }

    func showLoading() {
        output?.showLoading()
    }

    func hideLoading() {
        output?.hideLoading()
    }

    func success(with response: BaseResponse<RequestOTP.Response>) {
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
            output?.success(with: viewModel)
        default:
            output?.error(with: message)
        }
    }

    func error(with errorResponse: Error) {
        output?.error(with: errorResponse.localizedDescription)
    }
}
