extension Resources {
    enum Strings {
        static let dateFormat                   = "dd/MM/yyyy"
        static let taskBrowserTitle: String     = "Todos"
        static let settingsTitle: String        = "Settings"
        static let searchBarPlaceholder: String = "Search"
        static let contextMenuEdit              = "Edit"
        static let contextMenuShare             = "Share"
        static let contextMenuDelete            = "Delete"
        static let titleEmptyTask               = "New Task"
        static let titlePlaceholder             = "New Task"
        static let apiBasePath                  = "https://dummyjson.com"
        static let apiTodosEndpoint             = "/todos"
        static let apiRandomTodosEndpoint       = "/todos/random"
        static let apiQueryParamLimit           = "limit"
    }
}

extension Resources.Strings {
    enum UserDefaults {
        static let themeKey                     = "selectedTheme"
    }
}
