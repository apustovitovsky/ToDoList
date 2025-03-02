import Foundation

struct TaskDetailsFactory: Factory {
    
    func build(with task: TaskDetailsEntity, _ completion: Handler<TaskDetailsModuleOutput>? = nil) -> Presentable {
        let router = TaskDetailsRouter()
        completion?(router)
        
        let interactor = TaskDetailsInteractor(entity: task)
        
        let presenter = TaskDetailsPresenter(
            router: router,
            interactor: interactor
        )
        
        let view = TaskDetailsViewController(presenter: presenter)
        presenter.view = view
        interactor.presenter = presenter
        
        return view
    }
}
