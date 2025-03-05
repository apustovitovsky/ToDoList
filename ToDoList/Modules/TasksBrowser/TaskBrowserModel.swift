import Foundation

struct TaskBrowserModel {
    
    var state: State?
    var tasks: [TaskDetailsModel]
    
    init(state: State? = nil) {
        self.state = state
        self.tasks = []
    }
}

extension TaskBrowserModel {
    
    enum State {
        case normal
        case updating
        case deleting
        case creating
    }
}



