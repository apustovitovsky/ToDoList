import Foundation
import CoreData


extension TaskEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskEntity> {
        return NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var createdAt: Date?

}

extension TaskEntity : Identifiable {
    
    func toModel() -> TaskDetailsModel {
        TaskDetailsModel(
            id: self.id ?? UUID(),
            title: self.title ?? "",
            content: self.content ?? "",
            createdAt: self.createdAt ?? Date(),
            isCompleted: self.isCompleted
        )
    }
    
    func update(from model: TaskDetailsModel) {
        id = model.id
        title = model.title
        content = model.content
        createdAt = model.createdAt
        isCompleted = model.isCompleted
    }
}

