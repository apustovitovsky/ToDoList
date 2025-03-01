import UIKit

protocol TaskBrowserModuleOutput: AnyObject {
    var showTaskDetails: Handler<TaskDetailsEntity>? { get set }
}

class TaskBrowserRouter: DefaultRouter, TaskBrowserModuleOutput {
    var showTaskDetails: Handler<TaskDetailsEntity>?
}
