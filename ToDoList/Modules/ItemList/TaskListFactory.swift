//
//  TaskListFactory.swift
//  ToDoList
//

import UIKit

protocol TaskListFactoryProtocol {
    func build(with controller: UINavigationController) -> UIViewController
}

struct TaskListFactory: TaskListFactoryProtocol {
    func build(with controller: UINavigationController) -> UIViewController {
        let router = ItemListRouter()
        router.navigateToItemDetails = { uuid in
            print("navigating to \(uuid)")
            controller.pushViewController(TaskDetailsView(), animated: true)
        }
        let interactor = ItemListInteractor(entity: ItemListEntity(), service: TaskListService())
        let presenter = ItemListPresenter(interactor: interactor, router: router)
        let view = ItemListView(presenter: presenter)
        return view
    }
}

