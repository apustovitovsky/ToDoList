import Foundation
import CoreData


extension TaskEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskEntity> {
        return NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var createdAt: Date
}

extension TaskEntity : Identifiable {
    
    convenience init(context: NSManagedObjectContext, with model: TaskDetailsModel) {
        self.init(context: context)
        id = model.id
        title = model.title
        content = model.content
        createdAt = model.createdAt
        isCompleted = model.isCompleted
    }
    
    func toModel() -> TaskDetailsModel {
        TaskDetailsModel(
            id: self.id,
            title: self.title ?? "",
            content: self.content ?? "",
            createdAt: self.createdAt,
            isCompleted: self.isCompleted
        )
    }

    func update(by model: TaskDetailsModel) {
        title = model.title
        content = model.content
        createdAt = model.createdAt
        isCompleted = model.isCompleted
    }
}


