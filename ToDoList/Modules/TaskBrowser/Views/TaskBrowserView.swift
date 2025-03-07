import UIKit

final class TaskBrowserView: UIView {
    
    private lazy var loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = Resources.Colors.backgroundPrimary.withAlphaComponent(0.5)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }()
    
    private lazy var headerView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, settingsButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    lazy var settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Resources.Images.settings, for: .normal)
        button.tintColor = Resources.Colors.accentColor
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Resources.Strings.taskBrowserTitle
        label.textColor = Resources.Colors.primaryColor
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .left
        return label
     }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = TaskBrowserSearchBar()
        searchBar.showsBookmarkButton = true
        searchBar.setImage(UIImage(systemName: "mic.fill"), for: .bookmark, state: .normal)
        return searchBar
    }()

    lazy var tableView: UITableView = {
        let tableView = TaskBrowserTableView()
        tableView.register(TaskBrowserTableViewCell.self, forCellReuseIdentifier: TaskBrowserTableViewCell.identifier)

        return tableView
    }()
    
    lazy var footerView: TaskBrowserFooter = {
        let view = TaskBrowserFooter()
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

extension TaskBrowserView {
    func showLoading(_ show: Bool) {
        loadingView.isHidden = !show
    }
}

private extension TaskBrowserView {
 
    func setupSubviews() {
        [headerView, searchBar, tableView, footerView, loadingView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Resources.Constants.paddingMedium),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Resources.Constants.paddingMedium),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Resources.Constants.paddingMedium),
            
            searchBar.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: Resources.Constants.paddingSmall),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Resources.Constants.paddingSmall),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Resources.Constants.paddingSmall),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: Resources.Constants.paddingMedium),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            
            footerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: Resources.Constants.footerHeight),
            
            loadingView.topAnchor.constraint(equalTo: topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func setupUI() {
        backgroundColor = Resources.Colors.backgroundPrimary
    }
}




