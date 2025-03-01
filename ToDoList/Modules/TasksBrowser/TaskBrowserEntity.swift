import Foundation

struct TaskBrowserEntity {
    
    var state: State?
    var items: [TaskDetailsEntity]
    
    init(state: State? = nil) {
        self.state = state
        self.items = []
    }
}

extension TaskBrowserEntity {
    
    enum State {
        case normal
        case updating
        case deleting
        case creating
    }
}



