import Foundation
import CoreData

protocol TaskBrowserInteractorInput: AnyObject {
    
    var fetchedResultController: NSFetchedResultsController<TaskEntity> { get }
    
    func viewDidLoad()
    func fetchTasks()
    func fetchTasks(with filter: String)
    func fetchTasksFromNetwork(count: Int)
    func addEmptyTask()
    func modifyTask(_: TaskDetailsModel)
    func deleteTask(_: TaskDetailsModel)
}

final class TaskBrowserInteractor {
    
    weak var presenter: TaskBrowserInteractorOutput?
    private let persistentService: TaskStorageServiceProtocol
    private let networkService: TaskNetworkServiceProtocol
    private var model: TaskBrowserModel
    
    init(model: TaskBrowserModel,
         persistentService: TaskStorageServiceProtocol,
         networkService: TaskNetworkServiceProtocol) {
        self.model = model
        self.persistentService = persistentService
        self.networkService = networkService
    }
}

extension TaskBrowserInteractor: TaskBrowserInteractorInput {
    
    var fetchedResultController: NSFetchedResultsController<TaskEntity> {
        persistentService.fetchedResultsController
    }
    
    func viewDidLoad() {
        model.state = .normal
        presenter?.configure(with: model)
    }
    
    func fetchTasksFromNetwork(count: Int) {
        networkService.fetchTasks(count: count) { [weak self] result in
            guard let self = self, case .success(let tasks) = result else { return }
            persistentService.addTasks(tasks)
        }
    }
    
    func fetchTasks() {
        fetchTasks(with: "")
        
        if let objects = fetchedResultController.fetchedObjects, objects.isEmpty {
            self.fetchTasksFromNetwork(count: 5)
        }
    }
    
    func fetchTasks(with filter: String) {
        persistentService.fetchTasks(with: filter)
        presenter?.reloadData()
    }
    
    func addEmptyTask() {
        persistentService.addTasks([TaskDetailsModel.createEmpty])
    }
    
    func deleteTask(_ model: TaskDetailsModel) {
        persistentService.deleteTask(with: model.id)
    }
    
    func modifyTask(_ model: TaskDetailsModel) {
        persistentService.modifyTask(model)
    }
}

