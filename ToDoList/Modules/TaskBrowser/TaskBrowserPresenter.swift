import Foundation
import CoreData

protocol TaskBrowserPresenterInput: AnyObject {
    var fetchedResultController: NSFetchedResultsController<TaskEntity> { get }
    
    func viewDidLoad()
    func fetchTasks()
    func fetchTasks(with filter: String)
    func addTask()
    func modifyTask(_: TaskDetailsModel)
    func deleteTask(_: TaskDetailsModel)
    func showTaskDetails(_: TaskDetailsModel)
    func showSettings()
}

protocol TaskBrowserInteractorOutput: AnyObject {
    func reloadData()
    func configure(with _: TaskBrowserModel)
    func showTaskDetails(_: TaskDetailsModel)
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
    
    var fetchedResultController: NSFetchedResultsController<TaskEntity> {
        interactor.fetchedResultController
    }
    
    func viewDidLoad(){
        interactor.viewDidLoad()
    }
    
    func fetchTasks() {
        interactor.fetchTasks()
    }
    
    func fetchTasks(with filter: String) {
        interactor.fetchTasks(with: filter)
    }
    
    func addTask() {
        interactor.addEmptyTask()
        // show details
    }
    
    func modifyTask(_ model: TaskDetailsModel) {
        interactor.modifyTask(model)
    }
    
    func deleteTask(_ model: TaskDetailsModel) {
        interactor.deleteTask(model)
    }
    
    func showTaskDetails(_ model: TaskDetailsModel) {
        router.showTaskDetails?(model)
    }
    
    func showSettings() {
        router.showSettings?()
    }
}

extension TaskBrowserPresenter: TaskBrowserInteractorOutput {
    
    func reloadData() {
        view?.reloadData()
    }
    
    func configure(with model: TaskBrowserModel) {
        view?.configure(with: model)
    }
}

