import Swinject

internal final class Injector {

    static let shared = Injector.resolved()

    private static func resolved() -> Resolver {
        let assembler = Assembler()
        assembler.apply(assemblies: [
            Configurator(),
            MainConfigurator(),
            RequestOTPConfigurator(),
            LoginConfigurator()
        ])

        return assembler.resolver
    }
}
