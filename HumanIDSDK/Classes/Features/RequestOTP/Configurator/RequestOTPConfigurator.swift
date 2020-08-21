import RxSwift
import Swinject

internal final class RequestOTPConfigurator: Assembly {

    func assemble(container: Container) {
        container.register(RequestOTPWorkerProtocol.self) { (r) in
            let datasource = r.resolve(Network.self)!
            let worker = RequestOTPWorker()

            worker.datasource = datasource

            return worker
        }

        container.register(RequestOTPInteractorOutput.self) { (r, output: RequestOTPPresenterOutput) in
            let presenter = RequestOTPPresenter()
            presenter.output = output

            return presenter
        }

        container.register(RequestOTPInteractorInput.self) { (r, output: RequestOTPPresenterOutput) in
            let output = r.resolve(RequestOTPInteractorOutput.self, argument: output)!
            let worker = r.resolve(RequestOTPWorkerProtocol.self)!
            let interactor = RequestOTPInteractor()

            interactor.output = output
            interactor.worker = worker

            interactor.disposeBag = DisposeBag()

            return interactor
        }

        container.register(RequestOTPRouterProtocol.self) { (r, controller: RequestOTPViewController) in
            let router = RequestOTPRouter()
            router.controller = controller

            return router
        }

        container.register(RequestOTPViewController.self) { (r) in
            let controller = RequestOTPViewController()
            let input = r.resolve(RequestOTPInteractorInput.self, argument: controller as RequestOTPPresenterOutput)!
            let router = r.resolve(RequestOTPRouterProtocol.self, argument: controller)!

            controller.input = input
            controller.router = router

            return controller
        }
    }
}
