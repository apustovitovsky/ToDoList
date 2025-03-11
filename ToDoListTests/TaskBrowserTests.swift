import XCTest
@testable import ToDoList

final class TaskBrowserTests: XCTestCase {
    
    var presenter: TaskBrowserPresenter!
    var interactor: TaskBrowserInteractor!
    var router: TaskBrowserRouter!
    var view: MockTaskBrowserView!
    var storageService: MockTaskStorageService!
    var networkService: MockTaskNetworkService!
    
    override func setUp() {
        super.setUp()
        router = TaskBrowserRouter()
        storageService = MockTaskStorageService()
        networkService = MockTaskNetworkService()
        interactor = TaskBrowserInteractor(
            model: TaskBrowserModel(),
            storageService: storageService,
            networkService: networkService
        )
        presenter = TaskBrowserPresenter(router: router, interactor: interactor)
        view = MockTaskBrowserView()
        presenter.view = view
        interactor.presenter = presenter
    }
    
    override func tearDown() {
        presenter = nil
        interactor = nil
        router = nil
        view = nil
        storageService = nil
        networkService = nil
        super.tearDown()
    }
    
    func testViewDidLoad() {
        presenter.viewDidLoad()
        XCTAssertTrue(view.isConfigured)
    }
    
    func testFetchTasks() {
        presenter.fetchTasks()
        XCTAssertTrue(view.isReloaded)
    }
    
    func testAddTask() {
        presenter.addTask()
        XCTAssertTrue(view.isTaskDetailsShown)
    }
    
    func testModifyTask() {
        let task = TaskDetailsModel.createEmpty
        presenter.modifyTask(task)
        XCTAssertTrue(storageService.isTaskModified)
    }
    
    func testDeleteTask() {
        let task = TaskDetailsModel.createEmpty
        presenter.deleteTask(task)
        XCTAssertTrue(storageService.isTaskDeleted)
    }
    
    func testShowTaskDetails() {
        let task = TaskDetailsModel.createEmpty
        presenter.showTaskDetails(task)
        XCTAssertTrue(view.isTaskDetailsShown)
    }
    
    func testShowSettings() {
        presenter.showSettings()
        XCTAssertTrue(view.isSettingsShown)
    }
    
    func testTaskBrowserFactory() {
        let factory = TaskBrowserFactory(storageService: storageService, networkService: networkService)
        let step = factory.makeStep()
        
        XCTAssertTrue(step.module is TaskBrowserViewController)
        XCTAssertTrue(step.output is TaskBrowserRouter)
        
        let viewController = step.module as! TaskBrowserViewController
        XCTAssertNotNil(viewController.presenter)
        
        let presenter = viewController.presenter as! TaskBrowserPresenter
        XCTAssertNotNil(presenter.interactor)
        XCTAssertNotNil(presenter.router)
        
        let interactor = presenter.interactor as! TaskBrowserInteractor
        XCTAssertNotNil(interactor.storageService)
        XCTAssertNotNil(interactor.networkService)
    }
}

// Mock classes for testing
class MockTaskBrowserView: TaskBrowserPresenterOutput {
    var isConfigured = false
    var isReloaded = false
    var isTaskDetailsShown = false
    var isSettingsShown = false
    
    func configure(with model: TaskBrowserModel) {
        isConfigured = true
    }
    
    func reloadData() {
        isReloaded = true
    }
}

class MockTaskNetworkService: TaskNetworkServiceProtocol {
    var basePath: String = ""
    
    func fetchTasks(completion: @escaping ResultHandler<[TaskDetailsModel]>) {
        completion(.success([]))
    }
}
