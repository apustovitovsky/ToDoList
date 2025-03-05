import UIKit

protocol TaskBrowserPresenterOutput: AnyObject {
    func configure(with model: TaskBrowserModel)
}

final class TaskBrowserViewController: UIViewController {
    
    private let presenter: TaskBrowserPresenterInput
    private lazy var customView = TaskBrowserView()
    private var filterPrompt: String = ""
    private var tasks: [TaskDetailsModel] = []
    private var completedTasks: [TaskDetailsModel] = []
    private var filteredTasks: [TaskDetailsModel] = []
    
    init(presenter: TaskBrowserPresenterInput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        setupActions()
        setupDelegates()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Resources.Strings.taskBrowserTitle
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.moduleDidAppear()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

extension TaskBrowserViewController: TaskBrowserPresenterOutput {
    func configure(with model: TaskBrowserModel) {
        tasks = model.tasks
        customView.footerView.updateTaskCreationImage(model.state == .normal)
        refreshUI()
    }
}

extension TaskBrowserViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TaskBrowserTableViewCell.identifier, for: indexPath) as? TaskBrowserTableViewCell else {
            return UITableViewCell()
        }
        let task = filteredTasks[indexPath.row]
        cell.filterPrompt = filterPrompt
        cell.model = task
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(checkboxTapped(_:)))
        cell.addGestureRecognizer(tapGesture)

        return cell
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let task = filteredTasks[indexPath.row]
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: {
            guard let cell = tableView.cellForRow(at: indexPath) else { return nil }

            let view = TaskBrowserPreviewView(with: task)
            let viewController = UIViewController()
            viewController.view = view
            viewController.preferredContentSize = CGSize(
                width: cell.frame.width - Resources.Constants.paddingMedium - Resources.Constants.checkboxSize,
                height: cell.frame.height
            )
            return viewController
            
        }, actionProvider: { _ in
            let edit = UIAction(
                title: Resources.Strings.contextMenuEdit,
                image: Resources.Images.contextMenuEdit) { [weak self] _ in
                    self?.presenter.editTask(task)
            }
            let share = UIAction(
                title: Resources.Strings.contextMenuShare,
                image: Resources.Images.contextMenuShare) { _ in
                    print("Not implemented")
            }
            let delete = UIAction(
                title: Resources.Strings.contextMenuDelete,
                image: Resources.Images.contextMenuDelete,
                attributes: .destructive) { [weak self] _ in
                    self?.presenter.deleteTask(task)
            }
            return UIMenu(children: [edit, share, delete])
        })
    }
}

extension TaskBrowserViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterPrompt = searchText.lowercased()
        refreshUI()
    }
}

private extension TaskBrowserViewController {
    
    func refreshFilteredTasks() {
        filteredTasks = filterPrompt.count > 1 ? tasks.filter { task in
            task.title.lowercased().contains(filterPrompt.lowercased()) ||
            task.content.lowercased().contains(filterPrompt.lowercased())
        } : tasks
        completedTasks = filteredTasks.filter { $0.isCompleted }
    }
    
    func refreshUI() {
        refreshFilteredTasks()
        customView.footerView.updateProgressLabel(countCompleted: completedTasks.count, countTotal: filteredTasks.count)
        customView.tableView.reloadData()
    }
    
//    private func setupNavigationBar() {
//        title = Resources.Strings.taskBrowserTitle
//        let settingsButtonImage = Resources.Images.settings
//        let settingsButton = UIBarButtonItem(
//            image: settingsButtonImage,
//            style: .plain,
//            target: self,
//            action: #selector(settingsTapped)
//        )
//        navigationItem.rightBarButtonItem = settingsButton
//    }

    @objc private func settingsTapped() {
        presenter.settingsTapped()
    }
    
    @objc private func createTaskTapped() {
        presenter.createTask()
    }
    
    @objc private func checkboxTapped(_ sender: UITapGestureRecognizer) {
        guard
            let cell = sender.view as? TaskBrowserTableViewCell,
            let task = cell.model else { return }
        presenter.toggleCompletion(id: task.id)
    }
    
    func setupDelegates() {
        customView.tableView.delegate = self
        customView.tableView.dataSource = self
        customView.searchBar.delegate = self
    }
    
    func setupActions() {
        let createTaskTapGesture = UITapGestureRecognizer(target: self, action: #selector(createTaskTapped))
        customView.footerView.taskCreationImage.addGestureRecognizer(createTaskTapGesture)
        
        let settingsTapGesture = UITapGestureRecognizer(target: self, action: #selector(settingsTapped))
        customView.settingsButton.addGestureRecognizer(settingsTapGesture)
    }
}



