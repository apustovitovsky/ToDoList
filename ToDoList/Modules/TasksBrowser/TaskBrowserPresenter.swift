import Foundation

protocol TaskBrowserPresenterInput: AnyObject {
    func moduleWillAppear()
    func createTask()
    func editTask(_ task: TaskDetailsEntity)
    func deleteTask(_ task: TaskDetailsEntity)
    func toggleCompletion(id: UUID)
}

protocol TaskBrowserInteractorOutput: AnyObject {
    func configure(with entity: TaskBrowserEntity)
    func editTask(_ task: TaskDetailsEntity)
}

final class TaskBrowserPresenter {

    weak var view: TaskBrowserPresenterOutput?
    private let interactor: TaskBrowserInteractorInput
    private let router: TaskBrowserModuleOutput
    
    init(
        router: TaskBrowserModuleOutput,
        interactor: TaskBrowserInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
}

extension TaskBrowserPresenter: TaskBrowserPresenterInput {
    
    func createTask() {
        interactor.addTask()
    }
    
    func toggleCompletion(id: UUID) {
        interactor.toggleCompletion(id: id)
    }
    
    func moduleWillAppear() {
        interactor.updateTasks()
    }
    
    func editTask(_ task: TaskDetailsEntity) {
        router.showTaskDetails?(task)
    }
    
    func deleteTask(_ task: TaskDetailsEntity) {
        interactor.deleteTask(task)
    }
}

extension TaskBrowserPresenter: TaskBrowserInteractorOutput {
    func configure(with entity: TaskBrowserEntity) {
        view?.configure(with: entity)
    }
}

