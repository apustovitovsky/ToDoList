import CoreData
@testable import ToDoList

class MockTaskStorageService: TaskStorageServiceProtocol {
    var isTaskModified = false
    var isTaskDeleted = false
    
    var fetchedResultsController: NSFetchedResultsController<TaskEntity> {
        return NSFetchedResultsController()
    }
    
    func fetchTasks(with filter: String) {}
    func fetchTasksBackground(block: @escaping Handler<[TaskDetailsModel]>) {}
    func addTask(_ model: TaskDetailsModel) {}
    func addTasks(_ models: [TaskDetailsModel]) {}
    func deleteTask(with id: UUID) {
        isTaskDeleted = true
    }
    func modifyTask(_ model: TaskDetailsModel) {
        isTaskModified = true
    }
}
