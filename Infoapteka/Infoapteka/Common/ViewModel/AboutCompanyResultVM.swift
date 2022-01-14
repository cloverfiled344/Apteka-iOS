//
//  AboutCompanyResultVM.swift
//  Infoapteka
//
//  
//

import UIKit

final class AboutCompanyResultVM {
    
    private var aboutCompanyResult: AboutCompanyResult?
    private var _aboutHeaderText: [AboutHeaderText] = []
    private var aboutPageTypes: [AboutCompanyType] = [.desc, .phones, .emailAddress, .socialMedia, .map]
    private var cellMediaType: AboutCompanyType = .phones
    
    func getAboutPage(_ completion: @escaping(() -> Void)) {
        API.aboutAPI.getAboutCompanyResult { (aboutCompanResult, headerText, error) in
            guard error == nil else {
                BannerTop.showToast(message: error, and: .systemRed)
                completion()
                return
            }
            self.aboutCompanyResult = aboutCompanResult
            self._aboutHeaderText = headerText
            completion()
        }
    }
    
    // MARK: Properties
    var aboutHeaderText: [AboutHeaderText] {
        get {
            return self._aboutHeaderText
        }
    }
    
    var latitude: String? {
        get {
            self.aboutCompanyResult?.latitude
        }
    }
    
    var longitude: String? {
        get {
            self.aboutCompanyResult?.longitude
        }
    }
    
    // MARK: Getters
    func getAboutPagesType() -> [AboutCompanyType] {
        return aboutPageTypes
    }
    
    func getAboutPageType(_ by: Int) -> AboutCompanyType? {
        return aboutHeaderText.count > by ? aboutHeaderText[by].type : nil
    }
    
    func getAboutCompanyPage() -> AboutCompanyResult? {
        return self.aboutCompanyResult
    }
    
    func getPhonesCount() -> Int {
        return self.aboutCompanyResult?.phones.count ?? .zero
    }
    
    func getAboutSocialsCount() -> Int {
        return self.aboutCompanyResult?.aboutSocials.count ?? .zero
    }
    
    func getNumberOfSections() -> Int {
        return self.aboutPageTypes.count
    }
    
    func getPhoneNumber(_ by: Int) -> String? {
        return self.getPhonesCount() > by ? aboutCompanyResult?.phones[by] : nil
    }
    
    func getSoicalMedia(_ by: Int) -> AboutSocials? {
        return self.getAboutSocialsCount() > by ? aboutCompanyResult?.aboutSocials[by] : nil
    }
    
    func getCompanyTextHeader(_ section: Int) -> AboutCompanyType? {
        return _aboutHeaderText.count > section ? _aboutHeaderText[section].type : nil
    }
    
    func getNumberOfRowsInSection(_ tableView: UITableView, _ section: Int) -> Int {
        switch self.aboutPageTypes[section] {
        case .desc:
            return .zero
        case .phones:
            return 1
        case .emailAddress:
            return .zero
        case .socialMedia:
            return 1
        case .map:
            return .zero
        }
    }
    
    func getCellMediaType() -> AboutCompanyType {
        return self.cellMediaType
    }
    
    // MARK: Setters
    func setCellMediaType(_ type: AboutCompanyType) {
        self.cellMediaType = type
    }
}

