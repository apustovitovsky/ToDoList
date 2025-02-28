//
//  Factory.swift
//  ToDoList
//

protocol Factory {
    associatedtype Source
    associatedtype Output
    
    func build(with _: Source, _: Handler<Output>?) -> Presentable
}

extension Factory where Source == Void {
    func build(completion: Handler<Output>? = nil) -> Presentable {
        build(with: (), completion)
    }
}



