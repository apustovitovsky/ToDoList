struct TaskBrowserFactory: ModuleFactory {
    
    var storageService: TaskStorageServiceProtocol
    var networkService: TaskNetworkServiceProtocol
    
    func makeStep(with _: Void) -> RoutingStep<TaskBrowserRouter> {
        let router = TaskBrowserRouter()
        
        let interactor = TaskBrowserInteractor(
            model: TaskBrowserModel(),
            storageService: storageService,
            networkService: networkService
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
