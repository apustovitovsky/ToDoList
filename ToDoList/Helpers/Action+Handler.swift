typealias Action = () -> Void
typealias Handler<T> = (T) -> Void
typealias ResultHandler<T> = (Result<T, Error>) -> Void
