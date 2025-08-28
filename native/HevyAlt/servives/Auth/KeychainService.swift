import Foundation
import KeychainAccess

/// Сервис для безопасного хранения и извлечения токенов
final class KeychainService {
    static let shared = KeychainService()
    
    private let keychain = Keychain(service: "co.par4d0xy.HevyAlt.tokens")

    private let accessTokenKey = "access_token"
    private let accessTokenExpiryKey = "access_token_expiry"
    private let refreshTokenKey = "refresh_token"
    private let refreshTokenExpiryKey = "refresh_token_expiry"
    
    private init() {}
    
    // MARK: - Access Token
    
    func saveAccessToken(_ token: String) {
        let expiryDate = Date().addingTimeInterval(3600) // 1 час
        do {
            try keychain
                .set(token, key: accessTokenKey)
            try keychain
                .set(String(expiryDate.timeIntervalSince1970), key: accessTokenExpiryKey)
        } catch {
            print("Ошибка сохранения accessToken: \(error)")
        }
    }
    
    func getAccessToken() -> String? {
        do {
            guard let token = try keychain.get(accessTokenKey),
                  let expiryString = try keychain.get(accessTokenExpiryKey),
                  let expiryTimestamp = TimeInterval(expiryString) else {
                return nil
            }
            
            let expiryDate = Date(timeIntervalSince1970: expiryTimestamp)
            if Date() < expiryDate {
                return token
            } else {
                // Токен просрочен
                return nil
            }
        } catch {
            print("Ошибка получения accessToken: \(error)")
            return nil
        }
    }
    
    // MARK: - Refresh Token
    
    func saveRefreshToken(_ token: String) {
        let expiryDate = Date().addingTimeInterval(30 * 24 * 3600) // 30 дней
        do {
            try keychain
                .set(token, key: refreshTokenKey)
            try keychain
                .set(String(expiryDate.timeIntervalSince1970), key: refreshTokenExpiryKey)
        } catch {
            print("Ошибка сохранения refreshToken: \(error)")
        }
    }
    
    func getRefreshToken() -> String? {
        do {
            guard let token = try keychain.get(refreshTokenKey),
                  let expiryString = try keychain.get(refreshTokenExpiryKey),
                  let expiryTimestamp = TimeInterval(expiryString) else {
                return nil
            }
            
            let expiryDate = Date(timeIntervalSince1970: expiryTimestamp)
            if Date() < expiryDate {
                return token
            } else {
                // refresh-токен просрочен
                return nil
            }
        } catch {
            print("Ошибка получения refreshToken: \(error)")
            return nil
        }
    }
    
    // MARK: - Очистка
    
    func clearTokens() {
        do {
            try keychain.remove(accessTokenKey)
            try keychain.remove(accessTokenExpiryKey)
            try keychain.remove(refreshTokenKey)
            try keychain.remove(refreshTokenExpiryKey)
        } catch {
            print("Ошибка очистки токенов: \(error)")
        }
    }
}
