protocol StorageService: AnyObject {
    func createTasks(_ tasks: [TaskDetailsEntity], completion: Action?)
    func updateTasks(completion: @escaping ResultHandler<[TaskDetailsEntity]>)
    func modifyTasks(_ task: [TaskDetailsEntity], completion: Action?)
    func deleteTasks(_ tasks: [TaskDetailsEntity], completion: Action?)
}
