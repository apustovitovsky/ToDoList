protocol Configurable: AnyObject {
    associatedtype Context
    
    func configure(with _: Context)
}
