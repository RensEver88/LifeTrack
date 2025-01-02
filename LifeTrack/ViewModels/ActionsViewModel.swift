import Foundation
import SwiftUI

@MainActor
class ActionsViewModel: ObservableObject {
    @Published var actions: [Action] = []
    @Published var isEditMode = false
    
    private let saveKey = "savedActions"
    private let lastOpenedDateKey = "lastOpenedDate"
    
    init() {
        checkDate()
        loadActions()
    }
    
    private func checkDate() {
        let currentDate = Calendar.current.startOfDay(for: Date())
        
        if let lastOpenedData = UserDefaults.standard.object(forKey: lastOpenedDateKey) as? Date {
            let lastOpenedDate = Calendar.current.startOfDay(for: lastOpenedData)
            
            if currentDate != lastOpenedDate {
                // Nieuwe dag, reset alle lastTapped datums
                resetAllLastTappedDates()
            }
        }
        
        // Update de laatste openingsdatum
        UserDefaults.standard.set(currentDate, forKey: lastOpenedDateKey)
    }
    
    private func resetAllLastTappedDates() {
        for index in actions.indices {
            actions[index].lastTapped = nil
        }
        saveActions()
    }
    
    private func loadActions() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Action].self, from: data) {
            self.actions = decoded
        }
    }
    
    private func saveActions() {
        if let encoded = try? JSONEncoder().encode(actions) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    func addAction(name: String) {
        let action = Action(name: name)
        actions.append(action)
        saveActions()
    }
    
    func updateAction(_ action: Action) {
        if let index = actions.firstIndex(where: { $0.id == action.id }) {
            actions[index] = action
            saveActions()
        }
    }
    
    func deleteAction(_ action: Action) {
        actions.removeAll { $0.id == action.id }
        saveActions()
    }
    
    func incrementCount(for action: Action) {
        if let index = actions.firstIndex(where: { $0.id == action.id }) {
            var updatedAction = action
            updatedAction.count = min(action.count + 1, 9999)
            updatedAction.lastTapped = Date()
            actions[index] = updatedAction
            saveActions()
        }
    }
} 