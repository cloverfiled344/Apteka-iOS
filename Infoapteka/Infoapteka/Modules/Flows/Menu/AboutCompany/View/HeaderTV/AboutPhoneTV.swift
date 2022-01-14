//
//  AboutPhoneTV.swift
//  Infoapteka
//
//  
//

import UIKit
protocol AboutPhoneTVDelegate {
    func didTappedOnPhone(_ link: String?)
}

extension AboutPhoneTV {
    struct Appearance {
        
    }
}

final class AboutPhoneTV: UITableView {
    
    // MARK: Properties
    var _delegate: AboutPhoneTVDelegate?
    
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
    
    private var type: AboutCompanyType = .phones
    
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
extension AboutPhoneTV: UITableViewDataSource, UITableViewDelegate {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getPhonesCount() ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(AboutSocialMediaTVCell.self, indexPath: indexPath)
        guard let viewModel = viewModel else { return .init(frame: .zero) }
        cell.setupCell(viewModel.getPhoneNumber(indexPath.row),
                       type,
                       viewModel.getSoicalMedia(indexPath.row)?.logo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.pulsate(sender: tableView.cellForRow(at: indexPath) ?? .init())
        _delegate?.didTappedOnPhone(viewModel?.getPhoneNumber(indexPath.row))
    }
}
