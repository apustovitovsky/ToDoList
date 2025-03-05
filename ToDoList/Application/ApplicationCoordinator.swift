import Foundation

final class ApplicationCoordinator: Coordinator {
    
    private let router: Router
    private let themeProvider: ThemeProvider
    
    init(router: Router, themeProvider: ThemeProvider) {
        self.router = router
        self.themeProvider = themeProvider
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
        case .settings:
            showTaskList()
            showSettings(animated: true)
        }
    }
}

private extension ApplicationCoordinator {
    
    func showTaskList() {
        let step = TaskBrowserFactory().makeStep()
        
        step.output.showTaskDetails = { [weak self] task in
            self?.showEditTask(with: task, animated: true)
        }
        step.output.showSettings = { [weak self] in
            self?.showSettings(animated: true)
        }
        router.setRootModule(step)
    }
    
    func showEditTask(with model: TaskDetailsModel, animated: Bool) {
        let step = TaskDetailsFactory().makeStep(with: model)
        router.push(step, animated: animated)
    }
    
    func showSettings(animated: Bool) {
        let step = SettingsFactory(
            themeProvider: themeProvider
        ).makeStep()
        router.push(step, animated: animated)
    }
}

