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
        case .details(let task):
            showTaskList()
            showEditTask(with: task, animated: false)
        case .browser:
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
    
    func showEditTask(with task: TaskDetailsEntity, animated: Bool = true) {
        let module = TaskDetailsFactory().build(with: task)
        router.push(module, animated: animated)
    }
}

