//
//  DrugDetailVM.swift
//  Infoapteka
//
//  
//

import UIKit

enum DrugDetailType {
    case my
    case other
}

final class DrugDetailVM: NSObject {
    
    // MARK: Propeties
    private var type: DrugDetailType
    private var drugDetail: Drug?
    private var drugDetailCellType: [DrugDetailCellType] = [.slideShow, .desc, .instruction, .drugs]
    private var failedRequestCount: Int = .zero

    init(_ type: DrugDetailType = .other) {
        self.type = type
    }

    var instructionsCount: Int {
        get { return drugDetail?.instructions.count ?? .zero }
    }
    
    var similarCount: Int {
        get { return drugDetail?.similar.count ?? .zero }
    }
    
    var imagesCount: Int {
        get { return drugDetail?.images.count ?? .zero }
    }
    
    // MARK: Methods
    func fetchData(_ id: Int?, _ completion: @escaping(Int) -> Void) {
        guard let drugId = id else { return }
        API.drugDetailAPI.getDrugDetail(drugId, type) { (result, success) in
            if success {
                self.failedRequestCount = .zero
                self.drugDetail = result
                completion(.zero)
            } else {
                self.failedRequestCount += 1
                completion(self.failedRequestCount)
            }
        }
    }
    
    // MARK: Getters
    func getDrugDetail() -> Drug? { drugDetail }
    func getDrugDetailInstructTitle() -> String? { drugDetail?.instructTitle }
    func getDrugDetailInstructionTxt() -> String? { drugDetail?.instructionText }
    func getDrugDetailImages() -> [DrugDetailImage] { drugDetail?.images ?? [] }
    func getInstructionsResult() -> [DrugDetailInstruction] { drugDetail?.instructions ?? [] }
    func getMoreInstructions(by: Int) -> DrugDetailInstruction? {
        return instructionsCount > by ? drugDetail?.instructions[by] : nil
    }
    func getFreqDrugs() -> [Drug] { drugDetail?.similar ?? [] }
    func getDrugDetailCellType(by section: Int) -> DrugDetailCellType { drugDetailCellType[section] }
    func getNumberOfSections() -> Int { drugDetailCellType.count }
    
    func getNumberOfRowsInSection(_ section: Int) -> Int {
        switch drugDetailCellType[section] {
        case .slideShow, .desc: return 0
        case .drugs: return 1
        case .instruction:
            return (drugDetail?.addedByAdmin ?? false) ? instructionsCount : 0
        }
    }

    // MARK: Card Methods
    func changeFavourite(_ drug: Drug?,
                         _ completion: @escaping((Bool) -> Void)) {
        guard let drug = drug else { completion(false); return }
        API.basketAPI.changeFavourite(drug, !drug.isFavorites) { success in
            completion(success)
        }
    }
    
    func addToBasket(_ drug: Drug?, _ completion: @escaping(Bool) -> Void) {
        guard let drug = drug, let id = drug.id else { completion(false); return }
        API.drugDetailAPI.addToBasket(drug, id) { success in
            completion(success)
        }
    }
    
    func replaceDrugById(_ drug: Drug) {
        let drugIndex = drugDetail?.similar.firstIndex { $0.id == drug.id }
        guard let index = drugIndex else { return }
        drugDetail?.similar[index] = drug
    }

    func getType() -> DrugDetailType { type }
}
