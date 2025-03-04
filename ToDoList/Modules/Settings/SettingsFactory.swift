struct SettingsFactory: ModuleFactory {
    func makeStep(with _: Void) -> RoutingStep<SettingsRouter> {
        let router = SettingsRouter()
        
        let interactor = SettingsInteractor(
            model: SettingsModel()
        )
        let presenter = SettingsPresenter(
            router: router,
            interactor: interactor
        )
        let view = SettingsViewController(
            presenter: presenter
        )
        presenter.view = view
        interactor.presenter = presenter
        
        return RoutingStep(module: view, output: router)
    }
}



