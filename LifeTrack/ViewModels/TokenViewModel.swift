import Foundation
import SwiftUI
import os

@MainActor
class TokenViewModel: ObservableObject {
    @Published private(set) var tokens: [Token] = []
    private let saveKey = "savedTokens"
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.lifetrack", category: "TokenViewModel")
    
    init() {
        loadTokens()
    }
    
    private func loadTokens() {
        do {
            if let data = UserDefaults.standard.data(forKey: saveKey) {
                let decoder = JSONDecoder()
                tokens = try decoder.decode([Token].self, from: data)
                logger.info("Successfully loaded \(self.tokens.count) tokens")
            } else {
                logger.info("No saved tokens found")
            }
        } catch {
            logger.error("Failed to load tokens: \(error.localizedDescription)")
            // Reset to empty state on error
            tokens = []
        }
    }
    
    private func saveTokens() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(tokens)
            UserDefaults.standard.set(data, forKey: saveKey)
            logger.info("Successfully saved \(self.tokens.count) tokens")
        } catch {
            logger.error("Failed to save tokens: \(error.localizedDescription)")
        }
    }
    
    func addToken(_ text: String) {
        guard !text.isEmpty else {
            logger.warning("Attempted to add token with empty text")
            return
        }
        
        let token = Token(text: text)
        tokens.append(token)
        logger.info("Added new token: \(text)")
        saveTokens()
    }
    
    func removeToken(_ token: Token) {
        tokens.removeAll { $0.id == token.id }
        logger.info("Removed token: \(token.text)")
        saveTokens()
    }
    
    func removeAllTokens() {
        tokens.removeAll()
        logger.info("Removed all tokens")
        saveTokens()
    }
    
    // Voor debugging en testen
    var tokenCount: Int {
        tokens.count
    }
    
    func tokenExists(withText text: String) -> Bool {
        tokens.contains { $0.text == text }
    }
} 