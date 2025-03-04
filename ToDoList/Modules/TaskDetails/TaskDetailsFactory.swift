struct TaskDetailsFactory: ModuleFactory {
    
    func makeStep(with model: TaskDetailsModel) -> RoutingStep<TaskDetailsRouter> {
        let router = TaskDetailsRouter()

        let interactor = TaskDetailsInteractor(
            model: model
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
