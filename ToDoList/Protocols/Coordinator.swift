//
//  Coordinator.swift
//  ToDoList
//

protocol Coordinator {
    associatedtype Option
    func start()
    func start(with option: Option?)
}

extension Coordinator {
    func start() {
        start(with: nil)
    }
    func start(with option: Option?) {}
}
