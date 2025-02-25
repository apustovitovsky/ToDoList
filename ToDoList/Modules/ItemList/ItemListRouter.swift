//
//  ItemListRouter.swift
//  ToDoList
//

import UIKit

protocol ItemListRouterProtocol {
    var navigateToItemDetails: Handler<UUID>? { get set }
}

final class ItemListRouter: ItemListRouterProtocol {
    var navigateToItemDetails: Handler<UUID>?
}
