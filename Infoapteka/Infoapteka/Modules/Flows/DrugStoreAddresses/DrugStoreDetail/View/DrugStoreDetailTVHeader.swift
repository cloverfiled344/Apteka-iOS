//
//  DrugStoreDetailTVHeader.swift
//  Infoapteka
//
//  
//

import UIKit
import ImageSlideshowSDWebImage

// MARK: Appearance
extension DrugStoreDetailTVHeader {
    struct Appearance {
        let backColor: UIColor = Asset.mainWhite.color
        let titleNumberOfLines: Int = .zero
        let titleLblFont: UIFont = FontFamily.Inter.bold.font(size: 20)
        let statusLblFont: UIFont = FontFamily.Inter.regular.font(size: 14)
        let openStatusColor: UIColor = Asset.orange.color
        let closeStatusColor: UIColor = Asset.secondaryRed.color
        let distanceColor: UIColor = Asset.secondaryGray.color
        let blackColor: UIColor = Asset.mainBlack.color
        
        let slideCVHeight: CGFloat = Constants.screenHeight / (Constants.screenHeight / 374.0)
        let slideCVWidth: CGFloat = Constants.screenWidth - 40.0
        let pageIndicatorTintColor: UIColor = Asset.secondaryGray.color
        let currentPageTintColor: UIColor = Asset.orange.color
        let pageControlHeight: CGFloat = 8.0
        let leftRightMargin: CGFloat = 20.0
        
        let addressText: String = L10n.userAddress
        let workSheduleText: String = "График работы:"
        let phoneNumbersText: String = "Номер телефона:"
        let closeText: String = "Закрыто"
        let openText: String = "Сейчас открыто"
    }
}

// MARK: TVHeader
class DrugStoreDetailTVHeader: UITableViewHeaderFooterView {
    
    // MARK: UI Components
    private lazy var titleLbl = UILabel().then {
        $0.numberOfLines = appearance.titleNumberOfLines
    }
    
    private lazy var statusLbl = UILabel().then {
        $0.font = appearance.statusLblFont
    }
    
    private lazy var distanceLbl = UILabel().then {
        $0.font = appearance.statusLblFont
        $0.textColor = appearance.distanceColor
        $0.textAlignment = .right
    }
    
//
//    private lazy var slideCV: BannerCV = {
//        let view = BannerCV()
//
//        return view
//    }()
    
    private lazy var slideCV: DrugStoreDetailSlideCV = {
        let view = DrugStoreDetailSlideCV(frame: .zero)
        view._delegate = self
        return view
    }()
    
    private lazy var pageControl: UIPageControl = {
        let view = UIPageControl(frame: .zero)
        view.currentPage = .zero
        view.currentPageIndicatorTintColor = appearance.currentPageTintColor
        view.tintColor = appearance.pageIndicatorTintColor
        view.hidesForSinglePage = true
        return view
    }()
    
    private lazy var subtitleLbl = UILabel().then {
        $0.numberOfLines = .zero
    }
    
    // MARK: Properties
    private let appearance = Appearance()
    private var drugStore: DrugStore? {
        didSet {
            guard let drugStore = drugStore else { return }
            self.titleLbl.text = drugStore.name
            self.setupStyleOfStatusLbl(drugStore.isOpen)
            self.distanceLbl.text = drugStore.distance
            self.slideCV.setData(drugStore.images)
            self.pageControl.numberOfPages = drugStore.images.count
            
            setSubtitleAttr(subtitleLbl)
            setConstraints(drugStore.images.isEmpty)
        }
    }
    
    // MARK: Initialize
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = appearance.backColor
        contentView.addSubview(titleLbl)
        contentView.addSubview(statusLbl)
        contentView.addSubview(distanceLbl)
        contentView.addSubview(slideCV)
        contentView.addSubview(pageControl)
        contentView.addSubview(subtitleLbl)
    }
    
    private func setConstraints(_ isEmpty: Bool) {
        titleLbl.snp.remakeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(36.0)
            make.left.equalTo(contentView.snp.left).offset(appearance.leftRightMargin)
            make.right.equalTo(contentView.snp.right).offset(-appearance.leftRightMargin)
        }
        
        statusLbl.snp.remakeConstraints { make in
            make.top.equalTo(titleLbl.snp.bottom).offset(27.0)
            make.left.equalTo(contentView.snp.left).offset(appearance.leftRightMargin)
            make.right.equalTo(contentView.snp.right).offset(-appearance.leftRightMargin)
        }
        
        distanceLbl.snp.remakeConstraints { make in
            make.top.equalTo(titleLbl.snp.top)
            make.centerY.equalTo(titleLbl.snp.centerY)
            make.left.equalTo(titleLbl.snp.right).offset(appearance.leftRightMargin)
            make.right.equalTo(contentView.snp.right).offset(-appearance.leftRightMargin)
        }
        
        slideCV.snp.remakeConstraints { make in
            make.top.equalTo(statusLbl.snp.bottom).offset(12)
            make.right.left.equalToSuperview()
            make.height.equalTo(appearance.slideCVHeight)
        }
        
        pageControl.isHidden = isEmpty
        pageControl.snp.remakeConstraints { make in
            make.top.equalTo(slideCV.snp.bottom).offset(8.0)
            make.left.right.equalTo(slideCV)
            make.height.equalTo(appearance.pageControlHeight)
        }
        
        subtitleLbl.snp.remakeConstraints { make in
            make.top.equalTo(isEmpty ? statusLbl.snp.bottom : pageControl.snp.bottom).offset(isEmpty ? 12.0 : 27.0)
            make.left.equalTo(contentView.snp.left).offset(appearance.leftRightMargin)
            make.right.equalTo(contentView.snp.right).offset(-appearance.leftRightMargin)
            make.bottom.equalTo(contentView.snp.bottom).offset(-8.0)
        }
    }
    
    private func setSubtitleAttr(_ label: UILabel) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2.5
        let attr = NSMutableAttributedString(string: appearance.addressText,
                                             attributes: [.foregroundColor: appearance.distanceColor,
                                                          .font: appearance.statusLblFont, .paragraphStyle: paragraphStyle])
        attr.append(.init(string: "\n\(drugStore?.address ?? "")", attributes: [.foregroundColor: appearance.blackColor,
                                                                                .font: appearance.statusLblFont,
                                                                                .paragraphStyle: paragraphStyle]))
        attr.append(.init(string: "\n\n\(appearance.workSheduleText)", attributes: [.foregroundColor: appearance.distanceColor,
                                                                                  .font: appearance.statusLblFont,
                                                                                    .paragraphStyle: paragraphStyle]))
        attr.append(.init(string: "\n\(drugStore?.workHours ?? "")", attributes: [.foregroundColor: appearance.blackColor,
                                                                                  .font: appearance.statusLblFont,
                                                                                    .paragraphStyle: paragraphStyle]))
        if !(drugStore?.phones.isEmpty ?? false) {
            attr.append(.init(string: "\n\n\(appearance.phoneNumbersText)", attributes: [.foregroundColor: appearance.distanceColor,
                                                                                       .font: appearance.statusLblFont,
                                                                                       .paragraphStyle: paragraphStyle]))
        }
        label.attributedText = attr
    }
    
    private func setupStyleOfStatusLbl(_ isOpen: Bool) {
        statusLbl.text = isOpen ? appearance.openText : appearance.closeText
        statusLbl.textColor = isOpen ? appearance.openStatusColor : appearance.closeStatusColor
    }
    
    func setupHeader(_ drugStore: DrugStore?) {
        self.drugStore = drugStore
    }
}

extension DrugStoreDetailTVHeader: DrugStoreDetailSlideCVDelegate {
    
    func changedIndexPath(_ indexPath: IndexPath) {
        pageControl.currentPage = indexPath.row
    }
}
