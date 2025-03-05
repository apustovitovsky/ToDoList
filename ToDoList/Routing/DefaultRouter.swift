import UIKit

class DefaultRouter: Router {
    private weak var rootController: UINavigationController?
    
    init(rootController: UINavigationController? = nil) {
      self.rootController = rootController
    }
    
    func push(_ module: Presentable?)  {
      push(module, animated: true)
    }
    
    func push(_ module: Presentable?, animated: Bool)  {
        guard
          let controller = module?.toPresent(),
          (controller is UINavigationController == false)
          else { return }

        rootController?.pushViewController(controller, animated: animated)
    }
    
    func popModule()  {
      popModule(animated: true)
    }
    
    func popModule(animated: Bool)  {
      rootController?.popViewController(animated: animated)
    }
    
    func setRootModule(_ module: Presentable?) {
      setRootModule(module, hideBar: false)
    }
    
    func setRootModule(_ module: Presentable?, hideBar: Bool) {
      guard let controller = module?.toPresent() else { return }
      rootController?.setViewControllers([controller], animated: false)
      rootController?.isNavigationBarHidden = hideBar
    }
    
    func toPresent() -> UIViewController? {
      return rootController
    }
}
