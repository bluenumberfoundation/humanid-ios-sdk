import RxSwift
import Swinject

internal final class LoginConfigurator: Assembly {

    func assemble(container: Container) {
        container.register(LoginWorkerProtocol.self) { (r) in
            let datasource = r.resolve(Network.self)!
            let worker = LoginWorker()

            worker.datasource = datasource

            return worker
        }

        container.register(LoginInteractorOutput.self) { (r, output: LoginPresenterOutput) in
            let presenter = LoginPresenter()
            presenter.output = output

            return presenter
        }

        container.register(LoginInteractorInput.self) { (r, output: LoginPresenterOutput) in
            let output = r.resolve(LoginInteractorOutput.self, argument: output)!
            let worker = r.resolve(LoginWorkerProtocol.self)!
            let interactor = LoginInteractor()

            interactor.output = output
            interactor.worker = worker

            interactor.disposeBag = DisposeBag()

            return interactor
        }

        container.register(LoginRouterProtocol.self) { _ in
            return LoginRouter()
        }

        container.register(LoginViewController.self) { (r) in
            let controller = LoginViewController()
            let input = r.resolve(LoginInteractorInput.self, argument: controller as LoginPresenterOutput)!
            let router = r.resolve(LoginRouterProtocol.self)!

            controller.input = input
            controller.router = router

            return controller
        }
    }
}
