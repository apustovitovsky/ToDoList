struct TaskBrowserFactoryB: ModuleFactory {
    func makeStep(with _: Void) -> RoutingStep<TaskBrowserRouter> {
        let router = TaskBrowserRouter()
        
        let persistentService = TaskStorageService()
        
        
        let interactor = TaskBrowserInteractor(
            model: TaskBrowserModel(),
            persistentService: persistentService,
            networkService: TaskNetworkService.shared
        )
        let presenter = TaskBrowserPresenter(
            router: router,
            interactor: interactor
        )
        let view = TaskBrowserViewController(presenter: presenter)
        presenter.view = view
        interactor.presenter = presenter

        return RoutingStep(module: view, output: router)
    }
}
