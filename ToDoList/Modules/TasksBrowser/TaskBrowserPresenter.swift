import Foundation

protocol TaskBrowserPresenterInput: AnyObject {
    func moduleDidAppear()
    func createTask()
    func editTask(_: TaskDetailsModel)
    func deleteTask(_: TaskDetailsModel)
    func toggleCompletion(id: UUID)
    func settingsTapped()
}

protocol TaskBrowserInteractorOutput: AnyObject {
    func configure(with model: TaskBrowserModel)
    func editTask(_ model: TaskDetailsModel)
}

final class TaskBrowserPresenter {

    weak var view: TaskBrowserPresenterOutput?
    private let router: TaskBrowserModuleOutput
    private let interactor: TaskBrowserInteractorInput

    init(
        router: TaskBrowserModuleOutput,
        interactor: TaskBrowserInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
}

extension TaskBrowserPresenter: TaskBrowserPresenterInput {
    func settingsTapped() {
        router.showSettings?()
    }
    
    func createTask() {
        interactor.addTask()
    }
    
    func toggleCompletion(id: UUID) {
        interactor.toggleCompletion(id: id)
    }
    
    func moduleDidAppear() {
        interactor.updateTasks()
    }
    
    func editTask(_ task: TaskDetailsModel) {
        router.showTaskDetails?(task)
    }
    
    func deleteTask(_ task: TaskDetailsModel) {
        interactor.deleteTask(task)
    }
}

extension TaskBrowserPresenter: TaskBrowserInteractorOutput {
    func configure(with model: TaskBrowserModel) {
        view?.configure(with: model)
    }
}

