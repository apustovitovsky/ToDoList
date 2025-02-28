//
//  ToDoItemView.swift
//  ToDoList
//

import UIKit


final class TaskDetailsView: UIViewController {
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Task Detail"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()

    init(with task: TaskItemEntity) {
        super.init(nibName: nil, bundle: nil)
        label.text = task.title
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

private extension TaskDetailsView {

    func setupUI() {
        view.backgroundColor = .blue
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
