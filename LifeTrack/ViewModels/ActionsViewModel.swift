import Foundation
import SwiftUI
import os

@MainActor
class ActionsViewModel: ObservableObject {
    @Published private(set) var actions: [Action] = []
    @Published var isEditMode = false
    
    private let saveKey = "savedActions"
    private let lastOpenedDateKey = "lastOpenedDate"
    private let tokenViewModel: TokenViewModel
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.lifetrack", category: "ActionsViewModel")
    
    init(tokenViewModel: TokenViewModel) {
        self.tokenViewModel = tokenViewModel
        loadActions()  // Load actions first
        checkDate()    // Then check date to potentially reset lastTapped
    }
    
    private func checkDate() {
        let currentDate = Calendar.current.startOfDay(for: Date())
        
        if let lastOpenedData = UserDefaults.standard.object(forKey: lastOpenedDateKey) as? Date {
            let lastOpenedDate = Calendar.current.startOfDay(for: lastOpenedData)
            
            if currentDate != lastOpenedDate {
                resetAllLastTappedDates()
            }
        }
        UserDefaults.standard.set(currentDate, forKey: lastOpenedDateKey)
        UserDefaults.standard.synchronize() // Ensure the date is saved immediately
    }
    
    private func resetAllLastTappedDates() {
        for index in actions.indices {
            actions[index].lastTapped = nil
        }
        saveActions()
    }
    
    private func loadActions() {
        do {
            if let data = UserDefaults.standard.data(forKey: saveKey) {
                let decoder = JSONDecoder()
                actions = try decoder.decode([Action].self, from: data)
                logger.info("Successfully loaded \(self.actions.count) actions")
            } else {
                logger.info("No saved actions found")
                actions = []
            }
        } catch {
            logger.error("Failed to load actions: \(error.localizedDescription)")
            actions = []
        }
    }
    
    private func saveActions() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(actions)
            UserDefaults.standard.set(data, forKey: saveKey)
            UserDefaults.standard.synchronize() // Ensure actions are saved immediately
            logger.info("Successfully saved \(self.actions.count) actions")
        } catch {
            logger.error("Failed to save actions: \(error.localizedDescription)")
        }
    }
    
    func addAction(name: String, tokenMultiple: Int = 5, tokenText: String = "Achievement Token", startCount: Int = 0) {
        let action = Action(name: name, count: startCount, tokenMultiple: tokenMultiple, tokenText: tokenText)
        actions.append(action)
        saveActions()
        
        // Create initial tokens if needed
        if startCount > 0 {
            for count in 1...startCount {
                if action.shouldCreateToken(forCount: count) {
                    tokenViewModel.addToken(action.tokenText(forCount: count))
                }
            }
        }
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
        guard let index = actions.firstIndex(where: { $0.id == action.id }) else {
            logger.error("Failed to find action with id: \(action.id)")
            return
        }
        
        var updatedAction = action
        let newCount = action.count + 1
        
        // Update the action
        updatedAction.count = newCount
        updatedAction.lastTapped = Date()
        actions[index] = updatedAction
        saveActions()
        
        // Check if we should create a token
        if updatedAction.shouldCreateToken(forCount: newCount) {
            tokenViewModel.addToken(updatedAction.tokenText(forCount: newCount))
        }
    }
} 