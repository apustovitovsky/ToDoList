//
//  TaskDetailsRouter.swift
//  ToDoList
//

import UIKit

protocol TaskDetailsRouterProtocol: AnyObject {
    var showTaskList: Action? { get set }
}

class TaskDetailsRouter: DefaultRouter, TaskDetailsRouterProtocol {
    var showTaskList: Action?
}

