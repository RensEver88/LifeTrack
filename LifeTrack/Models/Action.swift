import Foundation

struct Action: Identifiable, Codable {
    let id: UUID
    var name: String
    var count: Int
    var lastTapped: Date?
    
    init(id: UUID = UUID(), name: String, count: Int = 0, lastTapped: Date? = nil) {
        self.id = id
        self.name = name
        self.count = count
        self.lastTapped = lastTapped
    }
    
    func canTapToday() -> Bool {
        guard let lastTapped = lastTapped else { return true }
        return !Calendar.current.isDate(lastTapped, inSameDayAs: Date())
    }
} 