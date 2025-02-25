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
