protocol SettingsInteractorInput: AnyObject {
    
}

final class SettingsInteractor {
    weak var presenter: SettingsInteractorOutput?
    var model: SettingsModel
    
    init(model: SettingsModel) {
        self.model = model
    }
}

extension SettingsInteractor: SettingsInteractorInput {
    
}

