//
//  ItemListEntity.swift
//  ToDoList
//

import Foundation

struct ItemListEntity {
    
    enum State {
        case normal
        case loading
    }
    
    struct TaskItem {
        let id: UUID
        var title: String
        var description: String
        let createdAt: Date
        var isCompleted: Bool
    }

    var state: State?
    var items: [TaskItem]
    
    init(state: State? = nil) {
        self.state = state
        self.items = []
    }
}



