import SwiftUI
import Combine

struct ValidationRequirement: Identifiable {
    var id = UUID()
    let name: String
    let validator: (String) -> Bool
    var isValid: Bool = false
}

class PasswordValidator: ObservableObject {
    @Published var password: String = ""
    @Published var isPasswordVisible: Bool = false
    @Published var requirements: [ValidationRequirement]
    @Published var isValid: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(requirements: [ValidationRequirement] = PasswordValidator.defaultRequirements) {
        self.requirements = requirements
        
        $password
            .sink { [weak self] password in
                self?.validatePassword(password)
            }
            .store(in: &cancellables)
    }
    
    private func validatePassword(_ password: String) {
        for i in 0..<requirements.count {
            requirements[i].isValid = requirements[i].validator(password)
            if !requirements[i].isValid {
                for j in (i + 1)..<requirements.count {
                    requirements[j].isValid = false
                }
                break
            }
        }
        
        isValid = requirements.allSatisfy { $0.isValid }
    }
    
    static var defaultRequirements: [ValidationRequirement] = [
        ValidationRequirement(
            name: "8 characters",
            validator: { $0.count >= 8 }
        ),
        ValidationRequirement(
            name: "Number",
            validator: { $0.contains(where: { $0.isNumber }) }
        ),
        ValidationRequirement(
            name: "Special character",
            validator: {
                let specialCharacters = CharacterSet(charactersIn: "!@#$%^&*()_-+=<>?/")
                return $0.unicodeScalars.contains(where: { specialCharacters.contains($0) })
            }
        )
    ]
}