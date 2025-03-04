import Foundation

struct TaskBrowserModel {
    
    var state: State?
    var items: [TaskDetailsModel]
    
    init(state: State? = nil) {
        self.state = state
        self.items = []
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



