//
//  MockService.swift
//  ToDoList
//

import Foundation

final class TasksStorageService_Mock: StorageService {
    
    static let shared = TasksStorageService_Mock()
    
    private init() {}
    
    private lazy var mockTasks: [TaskDetailsEntity] = {
        return (0..<Int.random(in: 10...50)).map { ind in generateTask(number: ind) }
    }()
    
    func saveContext(_ context: [TaskDetailsEntity], completion: @escaping ResultHandler<[TaskDetailsEntity]>) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.mockTasks = context
            completion(.success(context))
        }
    }
    
    func loadContext(completion: @escaping ResultHandler<[TaskDetailsEntity]>) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let tasks = self?.mockTasks else { return }
            completion(.success(tasks))
        }
    }
}

private extension TasksStorageService_Mock {
    
    func generateTask(number: Int) -> TaskDetailsEntity {
        let title = "\(number) \(randomSentence(wordCount: Int.random(in: 2...4)))"
        let description = "\(randomSentence(wordCount: Int.random(in: 5...25)))"
        return TaskDetailsEntity(title: title, description: description, isCompleted: Bool.random())
    }
    
    func randomSentence(wordCount: Int) -> String {
        guard wordCount > 0 else { return "" }
        
        let words = (0..<wordCount).map { _ in randomWord(syllables: Int.random(in: 1...2)) }
        
        guard let firstWord = words.first?.capitalized else { return "" }
        let remainingWords = words.dropFirst().map { $0.lowercased() }
        
        return ([firstWord] + remainingWords).joined(separator: " ") + "."
    }
    
    func randomWord(syllables: Int) -> String {
        let syllableShortParts: [String] = [
            "lo", "rem", "ip", "sum", "do", "lor", "si", "tam", "con", "sec",
            "tur", "ad", "ipis", "cing", "el", "it", "sed", "mo", "di", "tem",
            "por", "in", "ci", "den", "ut", "la", "bo", "re", "et", "mag",
            "na", "ali", "qua", "en", "im", "mi", "nim", "ve", "niam", "quis",
            "nos", "trud", "ex", "er", "ci", "ta", "tion", "ul", "lam", "co",
            "la", "bo", "ris", "ni", "si", "li", "quip", "com", "mo", "do",
            "con", "se", "quat", "duis", "au", "te", "ir", "ru", "dol", "or",
            "in", "re", "pre", "hen", "der", "vol", "up", "ta", "te", "ve",
            "lit", "es", "se", "cil", "lum", "eu", "fu", "gi", "at", "ex",
            "al", "brim", "fut", "sol", "quar", "sto", "lar", "erum", "zam",
            "pro", "gal", "am", "kil", "jo", "vul", "kro", "zic", "nav", "jet",
            "bok", "sal", "wom", "biz", "xen", "rex", "zap", "mol", "cil", "gaz",
            "hub", "lux", "fan", "lax", "ker", "won", "bom", "fix", "sto", "rit",
            "quim", "rum", "sil", "bar", "ber", "hol", "jaz", "ylo", "voz", "kim",
            "sux", "fab", "fan", "son", "tem", "mor", "hex", "lum", "ven", "caz",
            "zur", "rin", "pix", "tor", "jen", "dix", "vim", "bre", "ezi", "cal"
        ]
        let syllableLongParts: [String] = [
            "lorin", "emixa", "ipuso", "summex", "dorim", "lavor", "sivam", "tamina", "convia", "sectus",
            "turis", "adell", "ipidus", "cingor", "elora", "itium", "sedora", "moris", "divus", "tempa",
            "porin", "inalo", "civor", "denor", "utero", "lavia", "borex", "revin", "etuma", "magna",
            "natera", "alicos", "quavit", "enoro", "imera", "miron", "nimora", "verus", "niamus", "quista",
            "noscor", "trudin", "exilon", "erixa", "citura", "talor", "tialis", "ulmar", "lamor", "corvus",
            "lacrim", "bobrix", "riseta", "nivea", "simora", "lixor", "quipen", "cometa", "mordex", "dorius",
            "conrex", "serium", "quatix", "duisen", "aurex", "tenor", "irvus", "rulix", "dolior", "orbis",
            "invara", "redex", "prelis", "henor", "deron", "vola", "uprex", "tavix", "tebar", "venor",
            "litra", "esuna", "seron", "cilium", "lumina", "euphor", "futura", "givor", "atris", "exima",
            "alvus", "brimar", "fustor", "solena", "quaris", "storia", "larion", "erumus", "zamara",
            "proxim", "galore", "amoris", "kilena", "jovian", "vulcan", "kronix", "zicora", "navis", "jetta",
            "boktar", "salvia", "womira", "bizant", "xenora", "rexium", "zappo", "molten", "ciliar", "gazell",
            "hubris", "luxor", "fantis", "laxor", "kervin", "wontra", "bomina", "fixor", "storix", "ritora",
            "quimia", "rumina", "silvan", "barcus", "berion", "holux", "jazora", "ylaro", "vozium", "kimora",
            "suxora", "fabris", "fantra", "sonare", "temora", "morbis", "hexion", "luminum", "venius", "cazium",
            "zuron", "rinora", "pixium", "torex", "jentis", "dixor", "vimora", "brexis", "ezian", "caldor"
        ]
        guard syllables > 0 else { return "" }
        
        let word = (0..<syllables).map { _ in (syllableShortParts+syllableLongParts).randomElement() ?? "" }.joined()
        return word
    }
}
