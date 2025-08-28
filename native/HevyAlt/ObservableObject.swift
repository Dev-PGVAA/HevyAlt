import Foundation
import Combine

final class AuthViewModel: ObservableObject {
    @Published var accessToken: String?
    @Published var refreshToken: String?
    
    private let keychain = KeychainService.shared
    
    init() {
        loadTokens()
    }
    
    func loadTokens() {
        accessToken = keychain.getAccessToken()
        refreshToken = keychain.getRefreshToken()
    }
    
    func saveTokens(access: String, refresh: String) {
        keychain.saveAccessToken(access)
        keychain.saveRefreshToken(refresh)
        loadTokens()
    }
    
    func clearTokens() {
        keychain.clearTokens()
        accessToken = nil
        refreshToken = nil
    }
    
    var isAuthorized: Bool {
        return accessToken != nil || refreshToken != nil
    }
}
