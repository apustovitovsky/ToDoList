import XCTest
@testable import ToDoList

final class TaskDetailsTests: XCTestCase {
    
    var presenter: TaskDetailsPresenter!
    var interactor: TaskDetailsInteractor!
    var router: TaskDetailsRouter!
    var view: MockTaskDetailsView!
    var storageService: MockTaskStorageService!
    
    override func setUp() {
        super.setUp()
        router = TaskDetailsRouter()
        storageService = MockTaskStorageService()
        interactor = TaskDetailsInteractor(
            model: TaskDetailsModel.createEmpty,
            storageService: storageService
        )
        presenter = TaskDetailsPresenter(router: router, interactor: interactor)
        view = MockTaskDetailsView()
        presenter.view = view
        interactor.presenter = presenter
    }
    
    override func tearDown() {
        presenter = nil
        interactor = nil
        router = nil
        view = nil
        storageService = nil
        super.tearDown()
    }
    
    func testModuleDidLoad() {
        presenter.moduleDidLoad()
        XCTAssertTrue(view.isConfigured)
    }
    
    func testTitleDidChange() {
        let newTitle = "New Task Title"
        presenter.titleDidChange(newTitle)
        XCTAssertEqual(interactor.model.title, newTitle)
    }
    
    func testContentDidChange() {
        let newContent = "New Task Content"
        presenter.contentDidChange(newContent)
        XCTAssertEqual(interactor.model.content, newContent)
    }
    
    func testEditingDidFinish() {
        presenter.editingDidFinish()
        XCTAssertTrue(storageService.isTaskModified)
    }
    
    func testTaskDetailsFactory() {
        let factory = TaskDetailsFactory(storageService: storageService)
        let model = TaskDetailsModel.createEmpty
        let step = factory.makeStep(with: model)
        
        XCTAssertTrue(step.module is TaskDetailsViewController)
        XCTAssertTrue(step.output is TaskDetailsRouter)
        
        let viewController = step.module as! TaskDetailsViewController
        XCTAssertNotNil(viewController.presenter)
        
        let presenter = viewController.presenter as! TaskDetailsPresenter
        XCTAssertNotNil(presenter.interactor)
        XCTAssertNotNil(presenter.router)
        
        let interactor = presenter.interactor as! TaskDetailsInteractor
        XCTAssertNotNil(interactor.storageService)
    }
}

// Mock classes for testing
class MockTaskDetailsView: TaskDetailsPresenterOutput {
    var isConfigured = false
    
    func configure(with model: TaskDetailsModel) {
        isConfigured = true
    }
}
