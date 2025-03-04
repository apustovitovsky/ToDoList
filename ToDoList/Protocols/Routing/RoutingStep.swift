import UIKit

struct RoutingStep<T: Router>: Presentable {
    let module: Presentable
    let output: T

    func toPresent() -> UIViewController? {
        module.toPresent()
    }
}
