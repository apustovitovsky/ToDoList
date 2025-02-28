//
//  TaskListView.swift
//  ToDoList
//

import UIKit

protocol TaskBrowserPresenterOutput: AnyObject {
    func configure(with entity: TaskBrowserEntity)
}

final class TaskBrowserViewController: UIViewController {
    
    let presenter: TaskBrowserPresenterInput
    private lazy var customView = TaskBrowserView(presenter: presenter)
    
    init(presenter: TaskBrowserPresenterInput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = customView
    }
    
//    override func viewDidLoad() {
//        customView.addInteraction(
//            UIContextMenuInteraction(delegate: self)
//        )
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.updateEntity()
    }
}

extension TaskBrowserViewController: TaskBrowserPresenterOutput {
    func configure(with entity: TaskBrowserEntity) {
        customView.configure(with: entity)
    }
}

extension TaskBrowserViewController: UIContextMenuInteractionDelegate {

    func contextMenuInteraction(
        _ interaction: UIContextMenuInteraction,
        configurationForMenuAtLocation location: CGPoint
    ) -> UIContextMenuConfiguration? {
        
        // UIContextMenuConfiguration содержит previewProvider и actionProvider.
        // previewProvider — для превью (если нужно показать кастомный ViewController).
        // actionProvider — возвращает UIMenu с набором UIAction или вложенных UIMenu.
        
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: {
            // Опционально: возвращаем контроллер для превью (peek).
            // Если не нужен превью, можно вернуть nil.
            let previewVC = UIViewController()
            previewVC.view.backgroundColor = .systemBackground
            
            // Дополнительно настроим контент превью: например, лейблы, иконки и т.д.
            let label = UILabel(frame: CGRect(x: 20, y: 20, width: 200, height: 40))
            label.text = "Заняться спортом"
            label.font = UIFont.boldSystemFont(ofSize: 16)
            previewVC.view.addSubview(label)
            
            let descriptionLabel = UILabel(frame: CGRect(x: 20, y: 60, width: 250, height: 40))
            descriptionLabel.text = "Сходить в спортзал или сделать тренировку дома..."
            descriptionLabel.font = UIFont.systemFont(ofSize: 14)
            descriptionLabel.numberOfLines = 0
            previewVC.view.addSubview(descriptionLabel)
            
            return previewVC
        }, actionProvider: { _ in
            // Создаём действия меню
            let editAction = UIAction(
                title: "Редактировать",
                image: UIImage(systemName: "pencil")
            ) { _ in
                print("Нажали Редактировать")
            }
            
            let shareAction = UIAction(
                title: "Поделиться",
                image: UIImage(systemName: "square.and.arrow.up")
            ) { _ in
                print("Нажали Поделиться")
            }
            
            let deleteAction = UIAction(
                title: "Удалить",
                image: UIImage(systemName: "trash"),
                attributes: .destructive
            ) { _ in
                print("Нажали Удалить")
            }
            
            // Объединяем действия в меню
            return UIMenu(title: "Действия", children: [editAction, shareAction, deleteAction])
        })
    }
    
    // (Опционально) Настраиваем поведение после выбора пункта меню
    func contextMenuInteraction(
        _ interaction: UIContextMenuInteraction,
        willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration,
        animator: UIContextMenuInteractionCommitAnimating
    ) {
        // Например, можем пушить preview VC на Navigation Stack, если это нужно
        animator.addCompletion {
            guard let previewVC = animator.previewViewController else { return }
            self.navigationController?.pushViewController(previewVC, animated: true)
        }
    }
}


