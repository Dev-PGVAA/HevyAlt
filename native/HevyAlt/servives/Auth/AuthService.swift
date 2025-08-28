import Foundation

// MARK: - Модель ответа от сервера
struct AuthResponse: Codable {
    let accessToken: String
    let user: User
}

struct User: Codable {
    let id: String
    let email: String
    let name: String
}

// MARK: - Auth Service
final class AuthService: ObservableObject {
    static let shared = AuthService()
    
    private let baseURL = URL(string: "http://localhost:4200/api")!
    private let session: URLSession
    
    @Published var currentUser: User? = nil
    
    private init() {
        let config = URLSessionConfiguration.default
        config.httpCookieAcceptPolicy = .always
        config.httpShouldSetCookies = true
        config.httpCookieStorage = HTTPCookieStorage.shared
        self.session = URLSession(configuration: config)
    }
            
    func register(email: String, password: String, name: String, completion: @escaping (Bool) -> Void) {
        let url = baseURL.appendingPathComponent("auth/register")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let body = [
            "email": email,
            "password": password,
            "name": name
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Ошибка register: \(error)")
                DispatchQueue.main.async { completion(false) }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async { completion(false) }
                return
            }
            
            do {
                let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
                
                // Сохраняем токен
                KeychainService.shared.saveAccessToken(authResponse.accessToken)
                
                DispatchQueue.main.async {
                    self.currentUser = authResponse.user
                    completion(true)
                }
            } catch {
                print("Ошибка парсинга register: \(error)")
                DispatchQueue.main.async { completion(false) }
            }
        }.resume()
    }
    
    // MARK: - Авторизация
    func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
        let url = baseURL.appendingPathComponent("auth/login")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let body = ["email": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Ошибка запроса: \(error)")
                DispatchQueue.main.async { completion(false) }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async { completion(false) }
                return
            }
            
            do {
                let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
                
                // Сохраняем accessToken в Keychain
                KeychainService.shared.saveAccessToken(authResponse.accessToken)
                
                // Сохраняем пользователя в состоянии
                DispatchQueue.main.async {
                    self.currentUser = authResponse.user
                    completion(true)
                }
            } catch {
                print("Ошибка парсинга: \(error)")
                DispatchQueue.main.async { completion(false) }
            }
        }.resume()
    }
    
    // MARK: - Обновление Access Token
    func refreshToken(completion: @escaping (Bool) -> Void) {
        let url = baseURL.appendingPathComponent("auth/refresh")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Ошибка refresh: \(error)")
                DispatchQueue.main.async { completion(false) }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async { completion(false) }
                return
            }
            
            do {
                let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
                
                // Перезаписываем accessToken
                KeychainService.shared.saveAccessToken(authResponse.accessToken)
                
                DispatchQueue.main.async {
                    self.currentUser = authResponse.user
                    completion(true)
                }
            } catch {
                print("Ошибка парсинга refresh: \(error)")
                DispatchQueue.main.async { completion(false) }
            }
        }.resume()
    }
    
    // MARK: - Выход
    func logout(completion: @escaping (Bool) -> Void) {
        let url = baseURL.appendingPathComponent("auth/logout")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        session.dataTask(with: request) { _, _, error in
            if let error = error {
                print("Ошибка logout: \(error)")
                DispatchQueue.main.async { completion(false) }
                return
            }
            
            // Чистим токены
            KeychainService.shared.clearTokens()
            DispatchQueue.main.async {
                self.currentUser = nil
                completion(true)
            }
        }.resume()
    }
}
