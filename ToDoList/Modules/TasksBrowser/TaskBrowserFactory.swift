struct TaskBrowserFactory: ModuleFactory {
    func makeStep(with _: Void) -> RoutingStep<TaskBrowserRouter> {
        let router = TaskBrowserRouter()
        
        let interactor = TaskBrowserInteractor(
            model: TaskBrowserModel()
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
