import Foundation

struct NotificationSetting: Codable, Identifiable {
    var id: Int
    var time: Date
    var message: String
    var isEnabled: Bool
}

struct StoredSettings: Codable {
    var isNotificationsEnabled: Bool
    var notifications: [NotificationSetting]
}

class NotificationSettings: ObservableObject {
    @Published var isNotificationsEnabled: Bool {
        didSet {
            save()
        }
    }
    
    @Published var notifications: [NotificationSetting] {
        didSet {
            save()
        }
    }
    
    private let saveKey = "notificationSettings"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let stored = try? JSONDecoder().decode(StoredSettings.self, from: data) {
            self.notifications = stored.notifications
            self.isNotificationsEnabled = stored.isNotificationsEnabled
        } else {
            // Default settings
            self.notifications = [
                NotificationSetting(
                    id: 1,
                    time: Calendar.current.date(from: DateComponents(hour: 20, minute: 0)) ?? Date(),
                    message: "Don't forget to track your activities!",
                    isEnabled: true
                )
            ]
            self.isNotificationsEnabled = false
        }
    }
    
    private func save() {
        let settings = StoredSettings(
            isNotificationsEnabled: isNotificationsEnabled,
            notifications: notifications
        )
        
        if let encoded = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
} 