import XCTest
import CoreData
@testable import ToDoList

final class TaskDetailsTests: XCTestCase {
   var interactor: TaskDetailsInteractor!
   var presenter: TaskDetailsPresenter!
   var mockView: MockTaskDetailsView!
   var mockRouter: MockTaskDetailsRouter!
   var mockStorageService: MockTaskStorageServiceForDetails!

   override func setUp() {
       super.setUp()
       mockView = MockTaskDetailsView()
       mockRouter = MockTaskDetailsRouter()
       mockStorageService = MockTaskStorageServiceForDetails()

       let model = TaskDetailsModel.createEmpty
       interactor = TaskDetailsInteractor(model: model, storageService: mockStorageService)
       presenter = TaskDetailsPresenter(router: mockRouter, interactor: interactor)
       presenter.view = mockView
       interactor.presenter = presenter
   }

   override func tearDown() {
       interactor = nil
       presenter = nil
       mockView = nil
       mockRouter = nil
       mockStorageService = nil
       super.tearDown()
   }

   func testUpdateTitle() {
       let newTitle = "New Task"
       interactor.titleDidChange(newTitle)
       XCTAssertEqual(interactor.model.title, newTitle)
   }

   func testUpdateContent() {
       let newContent = "Task Content"
       interactor.contentDidChange(newContent)
       XCTAssertEqual(interactor.model.content, newContent)
   }

   func testEditingDidFinish() {
       interactor.editingDidFinish()
       if interactor.model.title.isEmpty && interactor.model.content.isEmpty {
           XCTAssertTrue(mockStorageService.deleteTaskCalled)
       } else {
           XCTAssertTrue(mockStorageService.modifyTaskCalled)
       }
   }

   func testModuleDidLoad() {
       presenter.moduleDidLoad()
       XCTAssertTrue(mockView.configureCalled)
   }
}

// MARK: - Mocks
final class MockTaskDetailsView: TaskDetailsPresenterOutput {
   var configureCalled = false

   func configure(with model: TaskDetailsModel) {
       configureCalled = true
   }
}

final class MockTaskDetailsRouter: TaskDetailsModuleOutput {}

final class MockTaskStorageServiceForDetails: TaskStorageServiceProtocol {
   var fetchedResultsController: NSFetchedResultsController<TaskEntity> {
       return NSFetchedResultsController()
   }

   var modifyTaskCalled = false
   var deleteTaskCalled = false

   func fetchTasks(with filter: String) {}
   func fetchTasksBackground(block: @escaping Handler<[TaskDetailsModel]>) {}
   func addTask(_ model: TaskDetailsModel) {}
   func addTasks(_ models: [TaskDetailsModel]) {}
   func deleteTask(with id: UUID) {
       deleteTaskCalled = true
   }
   func modifyTask(_ model: TaskDetailsModel) {
       modifyTaskCalled = true
   }
}
