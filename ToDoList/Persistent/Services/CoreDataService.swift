import Foundation
import CoreData

final class CoreDataService {
    
    static let shared = CoreDataService()
    
    private let persistentContainer: NSPersistentContainer
        
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "ToDoList")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Loading container error: \(error)")
            }
        }
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    private func newBackgroundContext() -> NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let context = newBackgroundContext()
        context.perform {
            block(context)
        }
    }

    func saveContext(_ context: NSManagedObjectContext) {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("Saving context error: \(error)")
        }
    }
}
