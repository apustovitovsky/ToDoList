struct TaskBrowserFactory: Factory {
    
    func build(with _: Void, _ completion: Handler<TaskBrowserModuleOutput>? = nil) -> Presentable {
        let router = TaskBrowserRouter()
        completion?(router)
        
        let interactor = TaskBrowserInteractor(
            entity: TaskBrowserEntity()
        )
        
        let presenter = TaskBrowserPresenter(
            router: router,
            interactor: interactor
        )

        let view = TaskBrowserViewController(presenter: presenter)
        presenter.view = view
        interactor.presenter = presenter

        return view
    }
}
