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
    var model: TaskBrowserModel
    private let storageService: TaskStorageServiceProtocol
    private let networkService: TaskNetworkServiceProtocol

    init(model: TaskBrowserModel,
         storageService: TaskStorageServiceProtocol,
         networkService: TaskNetworkServiceProtocol) {
        self.model = model
        self.storageService = storageService
        self.networkService = networkService
    }
}

extension TaskBrowserInteractor: TaskBrowserInteractorInput {
    
    var fetchedResultController: NSFetchedResultsController<TaskEntity> {
        storageService.fetchedResultsController
    }
    
    func viewDidLoad() {
        
//        #if DEBUG
//        storageService.deleteAllTasks()
//        #endif
        
        configureView(.normal)
        fetchTasks()
    }
    
    func fetchTasksFromNetwork(count: Int) {
        configureView(.fetching)
        networkService.fetchTasks { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let tasks):
                self.storageService.addTasks(tasks)
                self.configureView(.normal)
            case .failure(let error):
                print("Failed to fetch tasks from network: \(error)")
                self.configureView(.error)
            }
        }
    }
    
    func fetchTasks() {
        fetchTasks(with: "")
        
        if let objects = fetchedResultController.fetchedObjects, objects.isEmpty {
            self.fetchTasksFromNetwork(count: 2)
        }
    }
    
    func fetchTasks(with filter: String) {
        storageService.fetchTasks(with: filter)
        presenter?.reloadData()
    }
    
    func addEmptyTask() {
        let newTask = TaskDetailsModel.createEmpty
        storageService.addTask(newTask)
        presenter?.showTaskDetails(newTask)
    }
    
    func deleteTask(_ model: TaskDetailsModel) {
        storageService.deleteTask(with: model.id)
    }
    
    func modifyTask(_ model: TaskDetailsModel) {
        storageService.modifyTask(model)
    }
}

private extension TaskBrowserInteractor{
    
    func configureView(_ state: TaskBrowserModel.State) {
        model.state = state
        presenter?.configure(with: model)
    }
}
