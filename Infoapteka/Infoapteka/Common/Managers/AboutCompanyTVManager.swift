//
//  AboutCompanyTVManager.swift
//  Infoapteka
//
//  
//

import UIKit

protocol AboutCompanyTVManagerDelegate {
    func didTappedOnSocialMedia(_ link: String?)
    func didTappedOnPhone(_ phone: String?)
    func didTappedOnEmail(_ link: String?)
}

class AboutCompanyTVManager: NSObject {
    
    // MARK: Properties
    var delegate: AboutCompanyTVManagerDelegate?
    private var viewModel: AboutCompanyResultVM
    
    init(_ viewModel: AboutCompanyResultVM) {
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(_ completion: @escaping(() -> Void)) {
        viewModel.getAboutPage {
            completion()
        }
    }
}

// MARK: UITableViewDataSource and UITableViewDelegate
extension AboutCompanyTVManager: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getNumberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRowsInSection(tableView, section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch viewModel.getAboutPagesType()[section] {
        case .desc:
            return makeDescHeader(tableView, section)
        case .emailAddress:
            return makeAddressEmailHeader(tableView, section)
        case .map:
            return makeMapHeader(tableView, section)
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.getAboutPagesType()[indexPath.section] {
        case .phones:
            return makePhoneTVCell(tableView, indexPath, viewModel.getAboutPageType(indexPath.section))
        case .socialMedia:
            return makeSocialMediaTVCell(tableView, indexPath, viewModel.getAboutPageType(indexPath.section))
        default:
            return UITableViewCell(frame: .zero)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch viewModel.getAboutPagesType()[section] {
        case .phones:
            return .zero
        case .socialMedia:
            return .zero
        default: return UITableView.automaticDimension
        }
    }
    
    // MARK: Make Header
    private func makeDescHeader(_ tableView: UITableView, _ section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooter(AboutDescTVHeader.self)
        header.setupHeader(viewModel.getAboutCompanyPage())
        return header
    }
    
    private func makeAddressEmailHeader(_ tableView: UITableView, _ section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooter(AboutAddressTVHeader.self)
        header.delegate = self
        header.setupCell(viewModel.getAboutCompanyPage())
        return header
    }
    
    private func makeMapHeader(_ tableView: UITableView, _ section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooter(AboutCompanyMapTVHeader.self)
        header.setLoactions(viewModel.getAboutCompanyPage())
        return header
    }
    
    // MARK: Make Cell
    private func makeSocialMediaTVCell(_ tableView: UITableView, _ indexPath: IndexPath, _ type: AboutCompanyType?) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(AboutSocialsTVCell.self, indexPath: indexPath)
        cell.delegate = self
        cell.setupHeader(viewModel, type)
        return cell
    }
    
    private func makePhoneTVCell(_ tableView: UITableView, _ indexPath: IndexPath, _ type: AboutCompanyType?) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(AboutPhoneTVCell.self, indexPath: indexPath)
        cell.delegate = self
        cell.setupHeader(viewModel, type)
        return cell
    }
}

// MARK: Delegates
extension AboutCompanyTVManager: AboutSocialsTVCellDelegate,
                                 AboutPhoneTVCellDelegate,
                                 AboutAddressTVHeaderDelegate {
    func didTappedOnSocialMedia(_ link: String?) {
        delegate?.didTappedOnSocialMedia(link)
    }
    
    func didTappedOnPhone(_ link: String?) {
        delegate?.didTappedOnPhone(link)
    }
    
    func didTappedOnEmail(_ link: String?) {
        delegate?.didTappedOnEmail(link)
    }
}
