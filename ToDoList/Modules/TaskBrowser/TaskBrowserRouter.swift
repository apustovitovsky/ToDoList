import UIKit

protocol TaskBrowserModuleOutput: AnyObject {
    var showSettings: Action? { get set }
    var showTaskDetails: Handler<TaskDetailsModel>? { get set }

}

class TaskBrowserRouter: DefaultRouter, TaskBrowserModuleOutput {
    var showSettings: Action?
    var showTaskDetails: Handler<TaskDetailsModel>?
}
