import Foundation

struct ContentGenerator {
  
    func generateSentense(wordCount: Int) -> String {
        guard wordCount > 0 else { return "" }
        let words = (0..<wordCount).map { _ in randomWord(syllables: Int.random(in: 1...3)) }
        guard let firstWord = words.first?.capitalized else { return "" }
        let remainingWords = words.dropFirst().map { $0.lowercased() }
        return ([firstWord] + remainingWords).joined(separator: " ") + "."
    }
    
    func randomWord(syllables: Int) -> String {
        let syllableTwoLetters: [String] = [
            "lo", "re", "ip", "su", "do", "la", "si", "ta", "co", "se",
            "tu", "ad", "ci", "el", "it", "mo", "di", "po", "in", "la",
            "bo", "ma", "ni", "tr", "ex", "er", "te", "ul", "lam", "co",
            "ni", "si", "li", "mo", "du", "au", "ir", "ru", "do", "or",
            "re", "hen", "der", "vol", "up", "ta", "te", "ve", "li", "es"
        ]
        
        let syllableThreeLetters: [String] = [
            "lor", "rem", "sum", "dor", "lav", "siv", "con", "tur", "ad", "ipi",
            "cing", "sed", "mor", "div", "temp", "por", "den", "ute", "bor", "rev",
            "mag", "nat", "ali", "quav", "ime", "mir", "nim", "ver", "quis", "nosc",
            "trud", "exil", "erix", "cit", "tal", "tial", "ulma", "lam", "cor", "lacr",
            "ris", "niv", "sim", "lix", "quip", "com", "mord", "ser", "quat", "duis"
        ]
        
        let syllableFourLetters: [String] = [
            "lorin", "emix", "ipus", "summ", "dori", "lavo", "siva", "tami", "conv", "sect",
            "turi", "adel", "ipid", "cingo", "elor", "itiu", "sedo", "mori", "divu", "temp",
            "pori", "inal", "civo", "deno", "uter", "lavi", "bore", "revi", "etum", "magn",
            "nate", "alic", "quav", "enor", "imer", "miro", "nimo", "veru", "niam", "quis"
        ]
        
        guard syllables > 0 else { return "" }
        
        let word = (0..<syllables).map { _ in
            let pool = [syllableTwoLetters, syllableThreeLetters, syllableFourLetters].randomElement() ?? []
            return pool.randomElement() ?? ""
        }.joined()
        
        return word
    }
}
