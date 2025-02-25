//
//  ItemListInteractor.swift
//  ToDoList
//

import Foundation

protocol ItemListInteractorProtocol: AnyObject {
    var configure: Handler<ItemListEntity>? { get set }
    func updateItemList()
    func removeItem(id: UUID)
}

final class ItemListInteractor: ItemListInteractorProtocol {

    var entity: ItemListEntity
    var configure: Handler<ItemListEntity>?
    let service: TaskListServiceProtocol
    
    init(entity: ItemListEntity, service: TaskListServiceProtocol) {
        self.entity = entity
        self.service = service
    }
    
    func updateItemList() {
        entity.state = .loading
        
        service.mockData { [weak self] items in
            guard let self else { return }
            self.entity.items = items
            self.entity.state = .normal
            self.configure(with: entity)
        }
        
        configure(with: entity)
    }
    
    func removeItem(id: UUID) {
        entity.state = .loading
        configure(with: entity)
    }
}

private extension ItemListInteractor {
    func configure(with entity: ItemListEntity) {
        configure?(entity)
    }
}

