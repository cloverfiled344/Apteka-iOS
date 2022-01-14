//
//  InstructionsCVM.swift
//  Infoapteka
//
//  
//

import UIKit

final class InstructionsCVM {
    
    // MARK: Propeties
    private var instructions: [Instruction]
    
    var intructionsCount: Int {
        get {
            return instructions.count
        }
    }
    
    // MARK: Initialize
    init(_ instructions: [Instruction]) {
        self.instructions = instructions
    }
    
    // MARK: Getters
    func getInstructions() -> [Instruction] {
        return self.instructions
    }
    
    func getInstruction(by: Int) -> Instruction? {
        return self.intructionsCount > by ? self.instructions[by] : nil
    }
    
    func getInstructionType(by: Int) -> InstructionType {
        return self.instructions[by].type
    }
    
    // MARK: GET PRIVACY POLISY
    func getProgramRules(_ completion: @escaping((PrivacyPolicy?) -> Void)) {
        API.registerAPI.getPrivacyPolicy { result, errorMessage in
            guard errorMessage == nil else {
                BannerTop.showToast(message: errorMessage ?? "", and: .systemRed)
                completion(nil)
                return
            }
            completion(result)
        }
    }

}
