//
//  AboutSocialMediaTV.swift
//  Infoapteka
//
//  
//

import UIKit

protocol AboutSocialMediaTVDelegate {
    func didTappedOnSocialMedia(_ link: String?)
}

extension AboutSocialMediaTV {
    struct Appearance {
        
    }
}

final class AboutSocialMediaTV: UITableView {
    
    // MARK: Properties
    private var type: AboutCompanyType = .socialMedia
    var _delegate: AboutSocialMediaTVDelegate?
    
    override var contentSize: CGSize{
        didSet {
            if oldValue.height != self.contentSize.height {
                invalidateIntrinsicContentSize()
            }
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric,
                      height: contentSize.height)
    }
    
    private var viewModel: AboutCompanyResultVM? {
        didSet {
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }

    // MARK: Initialize
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        separatorStyle = .none
        registerdequeueReusableCell(AboutSocialMediaTVCell.self)
        dataSource = self
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(_ viewModel: AboutCompanyResultVM?, _ type: AboutCompanyType) {
        self.viewModel = viewModel
        self.type = type
    }
}

// MARK: UITableViewDataSource and UITableViewDelegate
extension AboutSocialMediaTV: UITableViewDataSource, UITableViewDelegate {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getAboutSocialsCount() ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(AboutSocialMediaTVCell.self, indexPath: indexPath)
        guard let viewModel = viewModel else { return .init(frame: .zero) }

        let text = viewModel.getCellMediaType() == .phones ? viewModel.getPhoneNumber(indexPath.row) : viewModel.getSoicalMedia(indexPath.row)?.title
        cell.setupCell(text,
                       type,
                       viewModel.getSoicalMedia(indexPath.row)?.logo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.pulsate(sender: tableView.cellForRow(at: indexPath) ?? .init())
        _delegate?.didTappedOnSocialMedia(viewModel?.getSoicalMedia(indexPath.row)?.link)
    }
}
