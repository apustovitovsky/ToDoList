import Foundation
import CoreData

protocol TaskStorageServiceProtocol {
    var fetchedResultsController: NSFetchedResultsController<TaskEntity> { get }
    
    func fetchTasks(with filter: String)
    func fetchTasksBackground(block: @escaping Handler<[TaskDetailsModel]>)
    func addTask(_ model: TaskDetailsModel)
    func addTasks(_ models: [TaskDetailsModel])
    func deleteTask(with id: UUID)
//    func deleteAllTasks()
//    func deleteEmptyTasks()
    func modifyTask(_: TaskDetailsModel)
}

fileprivate extension TaskEntity {
    static func fetchRequestSorted() -> NSFetchRequest<TaskEntity> {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "createdAt", ascending: false),
            NSSortDescriptor(key: "title", ascending: true)
        ]
        return request
    }
}

final class TaskStorageService: TaskStorageServiceProtocol {
    
    private let coreDataManager = CoreDataService.shared
    
    lazy var fetchedResultsController: NSFetchedResultsController<TaskEntity> = {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequestSorted()

        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataManager.mainContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        return controller
    }()

    func fetchTasks(with filter: String) {
        fetchedResultsController.fetchRequest.predicate = filter.isEmpty ? nil : NSPredicate(
            format: "(title CONTAINS[cd] %@ OR content CONTAINS[cd] %@)", filter, filter
        )
        try? self.fetchedResultsController.performFetch()
    }
    
    func fetchTasksBackground(block: @escaping Handler<[TaskDetailsModel]>) {
        coreDataManager.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            guard let tasks = try? context.fetch(fetchRequest) else { return }
            DispatchQueue.main.async {
                block(tasks.map {$0.toModel() })
            }
        }
    }
    
    func addTask(_ model: TaskDetailsModel) {
        addTasks([model])
    }
    
    func addTasks(_ models: [TaskDetailsModel]) {
        coreDataManager.performBackgroundTask { [weak self] context in
            models.forEach {
                let _ = TaskEntity(context: context, with: $0)
                print("added \($0.title )")
            }
            self?.coreDataManager.saveContext(context)
        }
    }

    func deleteTask(with id: UUID) {
        coreDataManager.performBackgroundTask { [weak self] context in
            if let task = self?.fetchTask(with: id, in: context) {
                print("deleted \(task.title ?? "No title")")
                context.delete(task)
                self?.coreDataManager.saveContext(context)
            }
        }
    }
    
//    func deleteAllTasks() {
//        coreDataManager.performBackgroundTask { [weak self] context in
//            let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
//            guard let tasks = try? context.fetch(fetchRequest) else { return }
//            tasks.forEach { context.delete($0) }
//            self?.coreDataManager.saveContext(context)
//        }
//    }
    
//    func deleteEmptyTasks() {
//        coreDataManager.performBackgroundTask { [weak self] context in
//            let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
//            fetchRequest.predicate = NSPredicate(format: "title == ''")
//            do {
//                let results = try context.fetch(fetchRequest)
//                results.forEach { context.delete($0) }
//                self?.coreDataManager.saveContext(context)
//            } catch {
//                print("Failed to fetch tasks: \(error)")
//            }
//        }
//    }

    func modifyTask(_ model: TaskDetailsModel) {
        coreDataManager.performBackgroundTask { [weak self] context in
            if let task = self?.fetchTask(with: model.id, in: context) {
                task.update(by: model)
                print("modified \(task.title ?? "No title")")
                self?.coreDataManager.saveContext(context)
            }
        }
    }

    private func fetchTask(with id: UUID, in context: NSManagedObjectContext) -> TaskEntity? {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        return try? context.fetch(fetchRequest).first
    }
    

}
