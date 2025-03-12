import XCTest
import CoreData
@testable import ToDoList

final class TaskBrowserTests: XCTestCase {

   var interactor: TaskBrowserInteractor!
   var presenter: TaskBrowserPresenter!
   var mockView: MockTaskBrowserView!
   var mockRouter: MockTaskBrowserRouter!
   var mockStorageService: MockTaskStorageService!
   var mockNetworkService: MockTaskNetworkService!

   override func setUp() {
       super.setUp()
       mockView = MockTaskBrowserView()
       mockRouter = MockTaskBrowserRouter()
       mockStorageService = MockTaskStorageService()
       mockNetworkService = MockTaskNetworkService()

       interactor = TaskBrowserInteractor(
           model: TaskBrowserModel(),
           storageService: mockStorageService,
           networkService: mockNetworkService
       )
       presenter = TaskBrowserPresenter(router: mockRouter, interactor: interactor)
       presenter.view = mockView
       interactor.presenter = presenter
   }

   override func tearDown() {
       interactor = nil
       presenter = nil
       mockView = nil
       mockRouter = nil
       mockStorageService = nil
       mockNetworkService = nil
       super.tearDown()
   }

   func testAddEmptyTask() {
       interactor.addEmptyTask()
       XCTAssertEqual(mockStorageService.addedTasks.count, 1)
       XCTAssertEqual(mockStorageService.addedTasks.first?.title, "")
   }

   func testFetchTasks() {
       interactor.fetchTasks()
       XCTAssertTrue(mockStorageService.fetchTasksCalled)
   }

   func testFetchTasksWithFilter() {
       let filter = "test"
       interactor.fetchTasks(with: filter)
       XCTAssertEqual(mockStorageService.fetchFilter, filter)
   }

   func testDeleteTask() {
       let task = TaskDetailsModel.createEmpty
       interactor.deleteTask(task)
       XCTAssertEqual(mockStorageService.deletedTaskID, task.id)
   }

   func testModifyTask() {
       let task = TaskDetailsModel.createEmpty
       interactor.modifyTask(task)
       XCTAssertEqual(mockStorageService.modifiedTask?.id, task.id)
   }

   func testPresenterShowTaskDetails() {
       let task = TaskDetailsModel.createEmpty
       presenter.showTaskDetails(task)
       XCTAssertTrue(mockRouter.showTaskDetailsCalled)
   }

   func testPresenterShowSettings() {
       presenter.showSettings()
       XCTAssertTrue(mockRouter.showSettingsCalled)
   }
}

// MARK: - Mocks

final class MockTaskBrowserView: TaskBrowserPresenterOutput {
   func configure(with model: TaskBrowserModel) {}
   func reloadData() {}
}

final class MockTaskBrowserRouter: TaskBrowserModuleOutput {
   lazy var showSettings: Action? = { [weak self] in
       self?.showSettingsCalled = true
   }
   lazy var showTaskDetails: Handler<TaskDetailsModel>? = { [weak self] _ in
       self?.showTaskDetailsCalled = true
   }
    
   var showSettingsCalled = false
   var showTaskDetailsCalled = false
}

final class MockTaskStorageService: TaskStorageServiceProtocol {
   var fetchedResultsController: NSFetchedResultsController<TaskEntity> {
       return NSFetchedResultsController()
   }

   var fetchTasksCalled = false
   var fetchFilter: String?
   var addedTasks = [TaskDetailsModel]()
   var deletedTaskID: UUID?
   var modifiedTask: TaskDetailsModel?

   func fetchTasks(with filter: String) {
       fetchTasksCalled = true
       fetchFilter = filter
   }

   func fetchTasksBackground(block: @escaping Handler<[TaskDetailsModel]>) {}

   func addTask(_ model: TaskDetailsModel) {
       addedTasks.append(model)
   }

   func addTasks(_ models: [TaskDetailsModel]) {
       addedTasks.append(contentsOf: models)
   }

   func deleteTask(with id: UUID) {
       deletedTaskID = id
   }

   func modifyTask(_ model: TaskDetailsModel) {
       modifiedTask = model
   }
}

final class MockTaskNetworkService: TaskNetworkServiceProtocol {
   var basePath: String = ""

   func fetchTasks(completion: @escaping ResultHandler<[TaskDetailsModel]>) {
       completion(.success([]))
   }

   func send<T>(request: T, completion: @escaping ResultHandler<T.Response>) throws where T : NetworkRequest {}
}
