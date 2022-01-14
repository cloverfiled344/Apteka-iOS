//
//  HomeVM.swift
//  Infoapteka
//
//  
//

import UIKit

final class HomeVM: NSObject {
    
    private var _banners        : [ImageBanner] = []
    private var _instructions   : [Instruction] = []
    private var _drugResult     : DrugResult?
    private var _isLoading      : Bool = false

    func fetchHomePage(_ completion: @escaping() -> Void) {
        _isLoading = false
        API.homeAPI.fetchHomePage { banners, instructions, drugResult in
            self.banners        = banners
            self._instructions  = instructions
            self._drugResult    = drugResult
            completion()
        }
    }

    func paginateDrugs(_ completion: @escaping(() -> Void)) {
        _isLoading = true
        guard let page = _drugResult?.next else {
            _isLoading = false
            completion()
            return
        }
        API.homeAPI.paginateDrugs(page) { drugResult in
            let totalResultsCounnt = self._drugResult?.results.count ?? 0 + drugResult.results.count
            if let count = self._drugResult?.count, count >= totalResultsCounnt,
               self._drugResult?.next != nil {
                self._drugResult?.results.append(contentsOf: drugResult.results)
                self._drugResult?.next = drugResult.next
            } else {
                self._drugResult = drugResult
            }
            completion()
        }
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

    var banners: [ImageBanner] {
        set { self._banners = newValue }
        get { return self._banners }
    }

    var instructions: [Instruction] {
        set { self._instructions = newValue }
        get { return self._instructions }
    }

    var drugResult: DrugResult {
        set { self._drugResult = newValue }
        get { return self._drugResult ?? .init(map: .init(mappingType: .fromJSON, JSON: [:])) }
    }

    var isLoading: Bool {
        set { self._isLoading = newValue }
        get { return self._isLoading }
    }
    
    func getDrug(_ by: Int) -> Drug? {
        let resultsCount: Int = self._drugResult?.results.count ?? 0
        return resultsCount > by ? self._drugResult?.results[by] : nil
    }
    
    func getDrugsCount() -> Int {
        return self._drugResult?.results.count ?? 0
    }

    func isHaveHits() -> Bool {
        !(_drugResult?.results.isEmpty ?? true)
    }

    func isPaginationNeeded(_ indexPath: IndexPath) -> Bool {
        return (indexPath.row == getDrugsCount() - 1  && self._drugResult?.next != nil) && !_isLoading && (drugResult.count ?? 0) > getDrugsCount()
    }
    
    func sizeForSectionHeaderViewForSection() -> CGSize {
        var height: CGFloat = 0
        if !_banners.isEmpty     { height = height + 268 }
        if !instructions.isEmpty { height = height + 152 }
        if !(_drugResult?.results.isEmpty ?? true) { height = height + 56 }
        return .init(width: Constants.screenWidth, height: height)
    }
    
    // MARK: Favourite
    func replaceDrugById(_ drug: Drug) {
        let drugIndex = drugResult.results.firstIndex { $0.id == drug.id }
        guard let index = drugIndex else { return }
        drugResult.results[index] = drug
    }
}
