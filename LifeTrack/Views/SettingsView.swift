import SwiftUI

struct SettingsView: View {
    @StateObject private var settings = NotificationSettings()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle("Enable Notifications", isOn: $settings.isNotificationsEnabled)
                } header: {
                    Text("Notifications")
                        .textCase(.uppercase)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if settings.isNotificationsEnabled {
                    Section {
                        Stepper("Number of notifications: \(settings.notifications.count)",
                               value: Binding(
                                get: { settings.notifications.count },
                                set: { newValue in
                                    if newValue > settings.notifications.count {
                                        let newId = settings.notifications.count + 1
                                        settings.notifications.append(
                                            NotificationSetting(
                                                id: newId,
                                                time: Calendar.current.date(from: DateComponents(hour: 20, minute: 0)) ?? Date(),
                                                message: "Don't forget to track your activities!",
                                                isEnabled: true
                                            )
                                        )
                                    } else if newValue < settings.notifications.count {
                                        settings.notifications.removeLast()
                                    }
                                }
                               ),
                               in: 1...3
                        )
                    }
                    
                    Section(header: Text("Daily Reminders")) {
                        ForEach($settings.notifications) { $notification in
                            HStack {
                                DatePicker("", selection: $notification.time, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                                    .frame(width: 100)
                                
                                TextField("Notification message", text: $notification.message)
                            }
                        }
                    }
                }
                
                Section {
                    HStack {
                        Spacer()
                        Text("Version 0.1")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarItems(leading: Button("Done") {
                dismiss()
            })
        }
    }
} 