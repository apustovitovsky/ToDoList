import XCTest
@testable import ToDoList

final class ServicesTests: XCTestCase {
    var storageService: TaskStorageService!
    var networkService: TaskNetworkService!

    override func setUp() {
        super.setUp()
        storageService = TaskStorageService()
        networkService = TaskNetworkService()
    }

    override func tearDown() {
        storageService = nil
        networkService = nil
        super.tearDown()
    }

    func testPersistentServiceCreateTask() {
        let expectation = XCTestExpectation(description: "Create task")
        let task = TaskDetailsModel.createEmpty

        storageService.addTask(task)

        storageService.fetchTasksBackground { tasks in
            XCTAssertTrue(tasks.contains(where: { $0.id == task.id }))
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testNetworkServiceFetchTasks() {
        let expectation = XCTestExpectation(description: "Fetch tasks")

        networkService.fetchTasks { result in
            switch result {
            case .success(let tasks):
                XCTAssertNotNil(tasks)
                XCTAssertFalse(tasks.isEmpty)
            case .failure(let error):
                XCTFail("Failed with error: \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }
}
