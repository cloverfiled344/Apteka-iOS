//
//  HelpResultVM.swift
//  Infoapteka
//
//  
//

import UIKit

final class HelpResultVM {
    
    // MARK: Properties
    private var helpResult: [HelpResult]?
    
    var helpPageCount: Int {
        get {
            return helpResult?.count ?? .zero
        }
    }
    
    // MARK: Methods
    func getHelpPage(_ completion: @escaping(() -> Void)) {
        API.helpAPI.getHelpPage { (result, error) in
            guard error == nil else {
                BannerTop.showToast(message: error, and: .systemRed)
                completion()
                return
            }
            self.helpResult = result
            completion()
        }
    }
    
    
    // MARK: Getters
    func getHelpByIndexPath(_ indexPath: IndexPath) -> HelpResult {
        return self.getHelpResult()[indexPath.row]
    }
    
    func getHelpResult() -> [HelpResult] {
        guard let result = self.helpResult else { return [] }
        return result
    }
}
