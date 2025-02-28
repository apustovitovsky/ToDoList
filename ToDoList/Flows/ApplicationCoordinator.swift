//
//  TaskListCoordinator.swift
//  ToDoList
//

import Foundation

final class ApplicationCoordinator: Coordinator {
    
    private let router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    func start(with option: LaunchOption?) {
        guard let option else {
            showTaskList()
            return
        }

        switch option {
        case .edit(let task):
            showTaskList()
            showEditTask(with: task, animated: false)
        default:
            showTaskList()
        }
    }
}

private extension ApplicationCoordinator {
    
    func showTaskList() {
        let module = TaskBrowserFactory().build { [weak self] output in
            output.showTaskDetails = { task in
                self?.showEditTask(with: task)
            }
        }
        router.setRootModule(module)
    }
    
    func showEditTask(with task: TaskItemEntity, animated: Bool = true) {
        let module = TaskDetailsFactory().build(with: task) { [weak self] output in
            output.showTaskList = {
                self?.router.popModule()
            }
        }
        router.push(module, animated: animated)
    }
}

