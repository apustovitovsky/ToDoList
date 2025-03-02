protocol Router: Presentable {
    func push(_ module: Presentable?)
    func push(_ module: Presentable?, animated: Bool)
    func popModule()
    func popModule(animated: Bool)
    func setRootModule(_ module: Presentable?)
    func setRootModule(_ module: Presentable?, hideBar: Bool)
}



