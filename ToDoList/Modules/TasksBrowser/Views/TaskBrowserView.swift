import UIKit

final class TaskBrowserView: UIView {
    
    struct Handlers {
        var createTask: Action
        var editTask: Handler<TaskDetailsEntity>
        var deleteTask: Handler<TaskDetailsEntity>
        var toggleCompletion: Handler<UUID>
    }
    
    var handlers: Handlers?
    var tasks: [TaskDetailsEntity] = []
    var taskItemsFiltered: [TaskDetailsEntity] {
        return !searchText.isEmpty
        ? tasks.filter {
            $0.title.lowercased().contains(searchText.lowercased()) ||
            $0.content.lowercased().contains(searchText.lowercased())
        }
        : tasks
    }
    var searchText: String = ""
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Resources.Strings.tasksLabel
        label.textColor = Resources.Colors.white
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .left
        return label
     }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = TaskBrowserSearchBar()
        searchBar.delegate = self
        return searchBar
    }()

    private lazy var tableView: UITableView = {
        let tableView = TaskBrowserTableView()
        tableView.register(TaskBrowserTableViewCell.self, forCellReuseIdentifier: TaskBrowserTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var footerView: TaskBrowserFooter = {
        let view = TaskBrowserFooter()
        view.onTaskCreateTap = { [weak self] in
            self?.handlers?.createTask()
        }
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupSubviews()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TaskBrowserView: TaskBrowserPresenterOutput {
    func configure(with entity: TaskBrowserEntity) {
        tasks = entity.items
        footerView.toggleTaskCreationView(entity.state == .normal)
        refreshUI()
    }
}

extension TaskBrowserView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskItemsFiltered.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskBrowserTableViewCell.identifier, for: indexPath) as? TaskBrowserTableViewCell
        else {
            return UITableViewCell()
        }
        let task = taskItemsFiltered[indexPath.row]
        
        cell.onCheckboxTapped = { [weak self] in
            self?.handlers?.toggleCompletion(task.id)
        }
        cell.getSearchText = { [weak self] in
            self?.searchText ?? String()
        }
        cell.configure(with: task)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let task = taskItemsFiltered[indexPath.row]
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: {
            guard let cell = tableView.cellForRow(at: indexPath) else { return nil }
            let cellWidth = cell.frame.width - Resources.Constants.paddingMedium - Resources.Constants.checkboxSize
            let cellHeight = cell.frame.height
            let preview = TaskBrowserPreviewCard(with: task)
            let previewVC = UIViewController()
            previewVC.view = preview
            previewVC.preferredContentSize = CGSize(width: cellWidth, height: cellHeight)
            return previewVC
            
//            let preview = TaskBrowserPreviewCard(with: task)
//            preview.translatesAutoresizingMaskIntoConstraints = false
//            let targetWidth = tableView.bounds.width
//            preview.widthAnchor.constraint(equalToConstant: targetWidth).isActive = true
//            preview.setNeedsLayout()
//            preview.layoutIfNeeded()
//            let fittingSize = preview.systemLayoutSizeFitting(
//                CGSize(width: targetWidth, height: UIView.layoutFittingCompressedSize.height),
//                withHorizontalFittingPriority: .required,
//                verticalFittingPriority: .fittingSizeLevel
//            )
//            let previewVC = UIViewController()
//            previewVC.view = preview
//            previewVC.preferredContentSize = fittingSize
//            return previewVC
        }, actionProvider: { _ in
            let edit = UIAction(
                title: Resources.Strings.contextMenuEdit,
                image: UIImage(systemName: "square.and.pencil")) { [weak self] _ in
                self?.handlers?.editTask(task)
            }
            let share = UIAction(
                title: Resources.Strings.contextMenuShare,
                image: UIImage(systemName: "square.and.arrow.up")) { [weak self] _ in
                self?.handlers?.editTask(task)
            }
            let delete = UIAction(
                title: Resources.Strings.contextMenuDelete,
                image: UIImage(systemName: "trash"),
                attributes: .destructive) { [weak self] _ in
                self?.handlers?.deleteTask(task)
            }
            return UIMenu(title: "", children: [edit, share, delete])
        })
    }
}

extension TaskBrowserView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText.lowercased()
        refreshUI()
    }
}

private extension TaskBrowserView {
    
    func refreshUI() {
        footerView.updateCountLabel(items: taskItemsFiltered)
        tableView.reloadData()
    }
    
    func setupSubviews() {
        [titleLabel, searchBar, tableView, footerView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Resources.Constants.paddingMedium),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Resources.Constants.paddingMedium),
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Resources.Constants.paddingSmall),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Resources.Constants.paddingMedium),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Resources.Constants.paddingMedium),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: Resources.Constants.paddingSmall),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            footerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: Resources.Constants.footerHeight)
        ])
    }
    
    func setupUI() {
        backgroundColor = Resources.Colors.black
    }
}




