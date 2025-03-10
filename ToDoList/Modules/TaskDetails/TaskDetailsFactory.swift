struct TaskDetailsFactory: ModuleFactory {
    
    var storageService: TaskStorageServiceProtocol
    
    func makeStep(with model: TaskDetailsModel) -> RoutingStep<TaskDetailsRouter> {
        let router = TaskDetailsRouter()

        let interactor = TaskDetailsInteractor(
            model: model,
            storageService: storageService
        )
        let presenter = TaskDetailsPresenter(
            router: router,
            interactor: interactor
        )
        let view = TaskDetailsViewController(presenter: presenter)
        presenter.view = view
        interactor.presenter = presenter
        
        return RoutingStep(module: view, output: router)
    }
}
