import UIKit

final class SettingsView: UIView {
    
    let themeSwitch = UISwitch()
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupSubviews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SettingsView {
    
    func setupUI() {
        backgroundColor = Resources.Colors.backgroundPrimary

    }
    
    func setupSubviews() {
        let generalSection = createSection(title: "Appearance", items: [
            createRow(title: "Dark Theme", control: themeSwitch)
        ])
        
        
        let stackView = UIStackView(arrangedSubviews: [generalSection])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    private func createSection(title: String, items: [UIView]) -> UIView {
        let titleLabel = UILabel()
        titleLabel.text = title.uppercased()
        titleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        titleLabel.textColor = Resources.Colors.secondaryColor
        
        let containerView = UIView()
        containerView.backgroundColor = Resources.Colors.backgroundSecondary
        containerView.layer.cornerRadius = Resources.Constants.cornerRadius
        
        let stackView = UIStackView(arrangedSubviews: items)
        stackView.axis = .vertical
        
        for (index, _) in items.enumerated() where index < items.count - 1 {
            let separator = createSeparator()
            stackView.addArrangedSubview(separator)
        }
        
        containerView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
        
        let sectionStack = UIStackView(arrangedSubviews: [titleLabel, containerView])
        sectionStack.axis = .vertical
        sectionStack.spacing = 8
        
        return sectionStack
    }
    
    private func createRow(title: String, control: UIView) -> UIView {
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 18)

        let stack = UIStackView(arrangedSubviews: [label, control])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        stack.distribution = .equalSpacing
        
        return stack
    }
    
    private func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        return separator
    }
}

