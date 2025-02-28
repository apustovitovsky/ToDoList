//
//  ItemListRouter.swift
//  ToDoList
//

import UIKit

protocol TaskBrowserModuleOutput: AnyObject {
    var showTaskDetails: Handler<TaskItemEntity>? { get set }
}

class TaskBrowserRouter: DefaultRouter, TaskBrowserModuleOutput {
    var showTaskDetails: Handler<TaskItemEntity>?
}
