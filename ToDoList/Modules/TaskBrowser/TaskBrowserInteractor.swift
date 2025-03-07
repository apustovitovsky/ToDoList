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
        
//        #if DEBUG
//        persistentService.deleteAllTasks()
//        #endif
        
        configureView(.normal)
        fetchTasks()
    }
    
    func fetchTasksFromNetwork(count: Int) {
        configureView(.fetching)
        networkService.fetchTasks(count: count) { [weak self] result in
            guard let self = self, case .success(let tasks) = result else { return }
            persistentService.addTasks(tasks)
            configureView(.normal)
        }
    }
    
    func fetchTasks() {
        fetchTasks(with: "")
        
        if let objects = fetchedResultController.fetchedObjects, objects.isEmpty {
            self.fetchTasksFromNetwork(count: 2)
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

private extension TaskBrowserInteractor{
    
    func configureView(_ state: TaskBrowserModel.State) {
        model.state = state
        presenter?.configure(with: model)
    }
}
