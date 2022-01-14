//
//  AboutPhoneTVCell.swift
//  Infoapteka
//
//  
//

import UIKit

protocol AboutPhoneTVCellDelegate {
    func didTappedOnPhone(_ link: String?)
}

extension AboutPhoneTVCell {
    struct Appearance {
        let backViewColor: UIColor = Asset.mainWhite.color
        let titleFont: UIFont = FontFamily.Inter.medium.font(size: 15)
        let titleTextColor: UIColor = Asset.mainBlack.color
        let phoneTitleText: String = "Наши телефоны:"
        let socialTitleText: String = "Мы в социальных сетях:"
    }
}

class AboutPhoneTVCell: UITableViewCell {
   
    
    
    // MARK: UI Components
    private lazy var backView = UIView().then {
        $0.backgroundColor = appearance.backViewColor
        $0.layer.cornerRadius = 16.0
        $0.layer.masksToBounds = true
    }
    
    private lazy var titleLbl = UILabel().then {
        $0.textColor = appearance.titleTextColor
        $0.font = appearance.titleFont
    }
    
    private lazy var tableView = AboutPhoneTV().then {
        $0.backgroundColor = appearance.backViewColor
//        $0.autoresizingMask = [.flexibleHeight]
        $0._delegate = self
    }
    
    // MARK: Properties
    var delegate: AboutPhoneTVCellDelegate?
    private let appearance = Appearance()
    private var viewModel: AboutCompanyResultVM? {
        didSet {
            guard let viewModel = viewModel else { return }
            tableView.setupData(viewModel, viewModel.getCellMediaType())
            makeConstraints()
        }
    }
    
    // MARK: Intitialize
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        selectionStyle = .none
        contentView.backgroundColor = Asset.backgroundGray.color
        contentView.addSubview(backView)
        backView.addSubview(titleLbl)
        backView.addSubview(tableView)
    }
    
    private func makeConstraints() {
        backView.snp.remakeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.bottom.equalTo(contentView.snp.bottom)
            make.left.right.equalTo(contentView).inset(20)
        }
        
        titleLbl.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.right.equalToSuperview().offset(20)
        }
        
        tableView.snp.remakeConstraints { make in
            make.top.equalTo(titleLbl.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-8)
        }
    }
    
    private func setTitleText(_ type: AboutCompanyType) {
        switch type {
        case .phones:
            titleLbl.text = appearance.phoneTitleText
        case .socialMedia:
            titleLbl.text = appearance.socialTitleText
        default:
            break
        }
    }
    
    func setupHeader(_ viewModel: AboutCompanyResultVM,
                     _ type: AboutCompanyType?) {
        guard let type = type else { return }
        setTitleText(type)
        self.viewModel = viewModel
    }
}

extension AboutPhoneTVCell: AboutPhoneTVDelegate {
    
    func didTappedOnPhone(_ link: String?) {
        delegate?.didTappedOnPhone(link)
    }
}
