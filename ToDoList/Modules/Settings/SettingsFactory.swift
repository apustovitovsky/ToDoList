struct SettingsFactory: ModuleFactory {
    
    private let themeProvider: ThemeProviderProtocol
    
    init(themeProvider: ThemeProviderProtocol) {
        self.themeProvider = themeProvider
    }
    
    func makeStep(with _: Void) -> RoutingStep<SettingsRouter> {
        let router = SettingsRouter()
        
        let interactor = SettingsInteractor(
            model: SettingsModel(),
            themeProvider: themeProvider
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



