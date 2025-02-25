//
//  ItemListPresenter.swift
//  ToDoList
//

import Foundation

protocol ItemListPresenterProtocol: AnyObject {
    var interactor: ItemListInteractorProtocol { get }
    var router: ItemListRouterProtocol { get }
    var configure: Handler<ItemListEntity>? { get set }
    func viewDidLoad()
    func modifyItem(id: UUID)
    func removeItem(id: UUID)
}

final class ItemListPresenter: ItemListPresenterProtocol {

    let interactor: ItemListInteractorProtocol
    let router: ItemListRouterProtocol
    var configure: Handler<ItemListEntity>?
    
    init(
        interactor: ItemListInteractorProtocol,
        router: ItemListRouterProtocol) {
            
        self.interactor = interactor
        self.router = router
        setupHandlers()
    }
    
    func viewDidLoad() {
        interactor.updateItemList()
    }
    
    func modifyItem(id: UUID) {
        router.navigateToItemDetails?(id)
    }
    
    func removeItem(id: UUID) {
        interactor.removeItem(id: id)
    }
}

private extension ItemListPresenter {
    func setupHandlers() {
        interactor.configure = { [weak self] entity in
            self?.configure(with: entity)
        }
    }
    
    func configure(with entity: ItemListEntity) {
        configure?(entity)
    }
}
