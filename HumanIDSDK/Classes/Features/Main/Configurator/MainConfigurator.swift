import Swinject

internal class MainConfigurator: Assembly {

    func assemble(container: Container) {
        container.register(MainRoutingLogic.self) { (r, view: MainViewController) in
            return MainRouter(view: view)
        }

        container.register(MainViewController.self) { (r) in
            let view = MainViewController()
            let router = r.resolve(MainRoutingLogic.self, argument: view)!
            view.router = router

            return view
        }
    }
}
