import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private var coordinator: ApplicationCoordinator?
    private var themeProvider: ThemeProviderProtocol = ThemeProvider()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let navigationController = AppNavigationController()
        window.rootViewController = navigationController
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applyTheme),
            name: ThemeProvider.themeDidChangeNotification,
            object: nil)
        
        coordinator = ApplicationCoordinator(
            router: DefaultRouter(rootController: navigationController),
            themeProvider: themeProvider,
            storageService: TaskStorageService(),
            networkService: TaskNetworkService()
        )
        
        self.window = window
        window.makeKeyAndVisible()
        
        coordinator?.start()
        applyTheme()
    }
    
    @objc private func applyTheme() {
        guard let window = window else { return }
        UIView.transition(with: window, duration: 0.4, options: .transitionCrossDissolve) { [weak self] in
            guard let theme = self?.themeProvider.effectiveTheme else { return }
            window.overrideUserInterfaceStyle = theme == .dark ? .dark : .light
        }
    }
    
    func windowScene(_ windowScene: UIWindowScene,
                     didUpdate previousCoordinateSpace: UICoordinateSpace,
                     interfaceOrientation: UIInterfaceOrientation,
                     traitCollection: UITraitCollection) {
        
        let newTheme: Theme = traitCollection.userInterfaceStyle == .dark ? .dark : .light
        themeProvider.setupTheme(to: newTheme)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
//        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

