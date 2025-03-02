protocol NetworkManager: AnyObject {
    associatedtype Context
    
    func saveContext(_: Context, completion: @escaping ResultHandler<Context>)
    func loadContext(completion: @escaping ResultHandler<Context>)
}

