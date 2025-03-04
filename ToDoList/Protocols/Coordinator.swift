import UIKit

protocol Coordinator {
    func start()
    func start(with option: LaunchOption?)
}

extension Coordinator {
    func start() {
        start(with: nil)
    }
}

