import Foundation

struct Action: Identifiable, Codable {
    let id: UUID
    var name: String
    var count: Int
    var lastTapped: Date?
    var tokenMultiple: Int
    var tokenText: String
    
    init(id: UUID = UUID(), name: String, count: Int = 0, lastTapped: Date? = nil, tokenMultiple: Int = 5, tokenText: String = "Achievement Token") {
        self.id = id
        self.name = name
        self.count = count
        self.lastTapped = lastTapped
        self.tokenMultiple = tokenMultiple
        self.tokenText = tokenText
    }
    
    func canTapToday() -> Bool {
        guard let lastTapped = lastTapped else { return true }
        return !Calendar.current.isDate(lastTapped, inSameDayAs: Date())
    }
    
    func shouldCreateToken(forCount count: Int) -> Bool {
        guard count > 0 && tokenMultiple > 0 else { return false }
        return count % tokenMultiple == 0
    }
    
    func tokenText(forCount count: Int) -> String {
        return tokenText
    }
} 