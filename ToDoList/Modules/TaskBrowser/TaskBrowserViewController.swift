import UIKit
import CoreData

protocol TaskBrowserPresenterOutput: AnyObject {
    func reloadData()
    func configure(with model: TaskBrowserModel)
}

final class TaskBrowserViewController: UIViewController {
    
    let presenter: TaskBrowserPresenterInput
    private lazy var customView = TaskBrowserView()
    private var fetchedResultController: NSFetchedResultsController<TaskEntity> {
        presenter.fetchedResultController
    }
    private var searchText: String = "" {
        didSet {
            debounceFetchTasks()
        }
    }
    private var searchTimer: Timer?
    
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
        presenter.viewDidLoad()
        title = Resources.Strings.taskBrowserTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

extension TaskBrowserViewController: TaskBrowserPresenterOutput {
    
    func configure(with model: TaskBrowserModel) {
        customView.footerView.setCreationEnabled(model.state != .creating)
        customView.showLoading(model.state == .fetching)
    }
    
    func reloadData() {
        customView.tableView.reloadData()
    }
}

extension TaskBrowserViewController: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        customView.tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        customView.tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let newIndexPath else { return }
            customView.tableView.insertRows(at: [newIndexPath], with: .left)
            
        case .delete:
            guard let indexPath else { return }
            customView.tableView.deleteRows(at: [indexPath], with: .right)
            
        case .update:
            guard let indexPath else { return }
            customView.tableView.reloadRows(at: [indexPath], with: .fade)
         
        case .move:
            guard let indexPath, let newIndexPath else { return }
            customView.tableView.moveRow(at: indexPath, to: newIndexPath)
            
        default:
            reloadData()
        }
    }
}

extension TaskBrowserViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultController.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TaskBrowserTableViewCell.identifier, for: indexPath) as? TaskBrowserTableViewCell else {
            return UITableViewCell()
        }
        let task = getTask(at: indexPath)
        cell.searchText = self.searchText
        cell.model = task

        // Add tap gesture to the checkboxImageView
        let checkboxTapGesture = UITapGestureRecognizer(target: self, action: #selector(checkboxTapped(_:)))
        cell.checkboxImageView.addGestureRecognizer(checkboxTapGesture)

        // Add tap gesture to the cell itself
        let cellTapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
        cell.addGestureRecognizer(cellTapGesture)

        return cell
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let task = getTask(at: indexPath)
        
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
                    self?.presenter.showTaskDetails(task)
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
        self.searchText = searchText.lowercased()
    }
}

private extension TaskBrowserViewController {
    
    func debounceFetchTasks() {
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(
            timeInterval: 0.5,
            target: self,
            selector: #selector(fetchTasksWithSearchText),
            userInfo: nil,
            repeats: false
        )
    }
    
    func getTask(at indexPath: IndexPath) -> TaskDetailsModel {
        return fetchedResultController.object(at: indexPath).toModel()
    }
    
    @objc private func fetchTasksWithSearchText() {
        presenter.fetchTasks(with: self.searchText)
    }
    
    @objc private func settingsTapped() {
        presenter.showSettings()
    }
    
    @objc private func createTaskTapped() {
        presenter.addTask()
    }
    
    @objc private func checkboxTapped(_ sender: UITapGestureRecognizer) {
        guard
            let checkboxImageView = sender.view as? UIImageView,
            let cell = checkboxImageView.superview?.superview as? TaskBrowserTableViewCell,
            var task = cell.model else { return }
        
        task.isCompleted.toggle()
        presenter.modifyTask(task)
    }

    @objc private func cellTapped(_ sender: UITapGestureRecognizer) {
        guard
            let cell = sender.view as? TaskBrowserTableViewCell,
            let task = cell.model else { return }
        
        presenter.showTaskDetails(task)
    }
    
    func setupDelegates() {
        customView.tableView.delegate = self
        customView.tableView.dataSource = self
        customView.searchBar.delegate = self
        fetchedResultController.delegate = self
    }
    
    func setupActions() {
        let createTaskTapGesture = UITapGestureRecognizer(target: self, action: #selector(createTaskTapped))
        customView.footerView.taskCreationImage.addGestureRecognizer(createTaskTapGesture)
        
        let settingsTapGesture = UITapGestureRecognizer(target: self, action: #selector(settingsTapped))
        customView.settingsButton.addGestureRecognizer(settingsTapGesture)
    }
}



