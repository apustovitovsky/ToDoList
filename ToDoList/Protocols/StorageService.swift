//
//  StorageService.swift
//  ToDoList
//

protocol StorageService: AnyObject {
    associatedtype Context
    
    func saveContext(_: Context, completion: @escaping ResultHandler<Context>)
    func loadContext(completion: @escaping ResultHandler<Context>)
}

