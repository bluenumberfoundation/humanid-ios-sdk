import Swinject

internal final class MainConfigurator: Assembly {

    func assemble(container: Container) {
        container.register(MainRouterProtocol.self) { (r, controller: MainViewController) in
            let router = MainRouter()
            router.controller = controller

            return router
        }

        container.register(MainViewController.self) { (r) in
            let controller = MainViewController()
            let router = r.resolve(MainRouterProtocol.self, argument: controller)!

            controller.router = router

            return controller
        }
    }
}
