//
//  ProfileViewModel.swift
//  RecapShopping
//
//  Created by Jaehui Yu on 2/23/24.
//

import Foundation

class ProfileViewModel {
    
    var inputText = Observable("")
    var outputIsEnabled = Observable(true)
    var outputText = Observable("")
    var outputColor = Observable(true)
    
    init() {
        inputText.bind { value in
            self.errorValidation(input: value)
        }
    }
    
    func errorValidation(input: String) {
        let forbiddenCharacters = ["@", "#", "$", "%"]
        let forbiddenNumbers = ["0","1","2","3","4","5","6","7","8","9"]
        
        do {
            let _ = try validateUserInputError(text: input)
            stateTextField("사용할 수 있는 닉네임이에요.", color: true, isEnabled: true)
        } catch {
            switch error {
            case ValidationError.isEmpty : stateTextField("", color: false, isEnabled: false)
            case ValidationError.sameAsBefore : stateTextField("이전과 같은 닉네임으로는 설정할 수 없어요", color: false, isEnabled: false)
            case ValidationError.lessThanCount: stateTextField("닉네임은 2글자 이상으로 설정해주세요.", color: false, isEnabled: false)
            case ValidationError.countExceeded: stateTextField("닉네임은 10글자 이내로 설정해주세요.", color: false, isEnabled: false)
            case ValidationError.forbiddenCharacters: stateTextField("닉네임에 @, #, $, %를 입력할 수 없어요.", color: false, isEnabled: false)
            case ValidationError.forbiddenNumbers: stateTextField("닉네임에 숫자는 입력할 수 없어요.", color: false, isEnabled: false)
            case ValidationError.startBlank: stateTextField("닉네임은 공백으로 시작할 수 없어요.", color: false, isEnabled: false)
            case ValidationError.continuousBlank: stateTextField("닉네임에 공백을 연속으로 사용할 수 없어요.", color: false, isEnabled: false)
            default: print(error)
            }
        }
        
        func validateUserInputError(text: String) throws -> Bool {
            guard !(text.isEmpty) else { throw ValidationError.isEmpty}
            guard !(text == UserDefaultsManager.shared.nickname) else { throw ValidationError.sameAsBefore }
            guard !(text.count < 2) else { throw ValidationError.lessThanCount }
            guard !(text.count > 10) else { throw ValidationError.countExceeded }
            guard !(forbiddenCharacters.contains { text.contains($0) }) else { throw ValidationError.forbiddenCharacters }
            guard !(forbiddenNumbers.contains { text.contains($0) }) else { throw ValidationError.forbiddenNumbers }
            guard text.first != " " else { throw ValidationError.startBlank }
            guard !text.contains("  ") else { throw ValidationError.continuousBlank }
            return true
        }
        
        func stateTextField(_ text: String, color: Bool, isEnabled: Bool) {
            outputText.value = text
            outputColor.value = color
            outputIsEnabled.value = isEnabled
        }
    }
}
