//
//  TaskListView.swift
//  ToDoList
//

import UIKit

protocol ItemListViewProtocol: UIViewController {
    var presenter: ItemListPresenterProtocol { get }
}

final class ItemListView: UIViewController, ItemListViewProtocol {
    
    let presenter: ItemListPresenterProtocol
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Task List"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    init(presenter: ItemListPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        setupHandlers()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }
}

private extension ItemListView {
    func setupHandlers() {
        presenter.configure = { [weak self] entity in
            self?.configure(with: entity)
        }
    }
    
    func configure(with entity: ItemListEntity) {
        print(entity.state as Any)
        if let state = entity.state, case .normal = state {
            print(entity.items.map{ String($0.title)}.joined(separator: ","))
            
            guard let randomItemUUID = entity.items.randomElement()?.id else { return }
            modifyItemDidTap(id: randomItemUUID)
        }
    }
    
    func modifyItemDidTap(id: UUID) {
        presenter.modifyItem(id: id)
    }
    
    func removeItemDidTap(id: UUID) {
        presenter.removeItem(id: id)
    }
    
    func setupUI() {
        view.backgroundColor = .red
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
