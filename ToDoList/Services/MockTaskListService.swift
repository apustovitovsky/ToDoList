//
//  TaskListService.swift
//  ToDoList
//

//import Foundation
//
//protocol TaskListServiceProtocol: AnyObject {
//    func addTask(task: TaskItemEntity, completion: ResultHandler<TaskItemEntity>)
//    func getTasks(completion: @escaping ResultHandler<[TaskItemEntity]>)
//    func getTask(id: UUID) -> TaskItemEntity?
//    func setTask(task: TaskItemEntity, completion: @escaping ResultHandler<TaskItemEntity>)
//    func removeTask(id: UUID)
//}
//
//final class MockTaskListService: TaskListServiceProtocol {
//    
//    private lazy var mockTasks: [TaskItemEntity] = {
//        return (0..<Int.random(in: 5...25)).map { _ in generateTask() }
//    }()
//    
//    private func generateTask() -> TaskItemEntity {
//        let uuid = UUID()
//        let title = "\(randomSentence(wordCount: Int.random(in: 2...4)))"
//        let description = "\(randomSentence(wordCount: Int.random(in: 5...7)))"
//        return TaskItemEntity(id: uuid, title: title, description: description, createdAt: Date(), isCompleted: Bool.random())
//    }
//    
//    func randomSentence(wordCount: Int) -> String {
//        guard wordCount > 0 else { return "" }
//        
//        let words = (0..<wordCount).map { _ in randomWord(syllables: Int.random(in: 1...5)) }
//        
//        guard let firstWord = words.first?.capitalized else { return "" }
//        let remainingWords = words.dropFirst().map { $0.lowercased() }
//        
//        return ([firstWord] + remainingWords).joined(separator: " ") + "."
//    }
//    
//    func randomWord(syllables: Int) -> String {
//        let syllableParts: [String] = [
//            "lo", "rem", "ip", "sum", "do", "lor", "si", "tam", "con", "sec",
//            "tur", "ad", "ipis", "cing", "el", "it", "sed", "mo", "di", "tem",
//            "por", "in", "ci", "den", "ut", "la", "bo", "re", "et", "mag",
//            "na", "ali", "qua", "en", "im", "mi", "nim", "ve", "niam", "quis",
//            "nos", "trud", "ex", "er", "ci", "ta", "tion", "ul", "lam", "co",
//            "la", "bo", "ris", "ni", "si", "li", "quip", "com", "mo", "do",
//            "con", "se", "quat", "duis", "au", "te", "ir", "ru", "dol", "or",
//            "in", "re", "pre", "hen", "der", "vol", "up", "ta", "te", "ve",
//            "lit", "es", "se", "cil", "lum", "eu", "fu", "gi", "at", "ex",
//            "al", "brim", "fut", "sol", "quar", "sto", "lar", "erum", "zam",
//            "pro", "gal", "am", "kil", "jo", "vul", "kro", "zic", "nav", "jet",
//            "bok", "sal", "wom", "biz", "xen", "rex", "zap", "mol", "cil", "gaz",
//            "hub", "lux", "fan", "lax", "ker", "won", "bom", "fix", "sto", "rit",
//            "quim", "rum", "sil", "bar", "ber", "hol", "jaz", "ylo", "voz", "kim",
//            "sux", "fab", "fan", "son", "tem", "mor", "hex", "lum", "ven", "caz",
//            "zur", "rin", "pix", "tor", "jen", "dix", "vim", "bre", "ezi", "cal"
//        ]
//        guard syllables > 0 else { return "" }
//        
//        let word = (0..<syllables).map { _ in syllableParts.randomElement() ?? "" }.joined()
//        return word
//    }
//    
//    func getTasks(completion: @escaping ResultHandler<[TaskItemEntity]>) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
//            guard let tasks = self?.mockTasks else { return }
//            completion(.success(tasks))
//        }
//    }
//    
//    func getTask(id: UUID) -> TaskItemEntity? {
//        mockTasks.first { $0.id == id }
//    }
//    
//    func removeTask(id: UUID) {
//        mockTasks = mockTasks.filter { $0.id != id }
//    }
//    
//    func addTask(task: TaskItemEntity, completion: ResultHandler<TaskItemEntity>) {
//        if let _ = mockTasks.firstIndex(where: { $0.id == task.id }) {
//            completion(.failure(NSError()))
//        } else {
//            mockTasks.append(task)
//            completion(.success(task))
//        }
//    }
//    
//    func setTask(task: TaskItemEntity, completion: @escaping ResultHandler<TaskItemEntity>) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
//            if let index = self?.mockTasks.firstIndex(where: { $0.id == task.id }) {
//                self?.mockTasks[index] = task
//                completion(.success(task))
//            } else {
//                completion(.failure(NSError()))
//            }
//        }
//    }
//}

