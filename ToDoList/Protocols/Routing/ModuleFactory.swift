protocol ModuleFactory {
    associatedtype Context
    associatedtype R: Router
    
    func makeStep(with _: Context) -> RoutingStep<R>
}

extension ModuleFactory where Context == Void {
    func makeStep() -> RoutingStep<R> {
        makeStep(with: ())
    }
}

