//
//  HomeCVHeader.swift
//  Infoapteka
//
//  
//

import UIKit
import ImageSlideshow
import ImageSlideshowSDWebImage

protocol HomeCVHeaderDelgate {
    func pushToMapPage()
    func pushToDeliveryPage(_ programPolicy: PrivacyPolicy?)
    func pushToInstructionPage(_ programPolicy: PrivacyPolicy?)
    func openBannerByLink(_ link: String)
}

// MARK: Appearance
extension HomeCVHeader {
    struct Appearance {
        let backgroundColor             : UIColor = Asset.backgroundGray.color
        let slideShowIndicatorPosition  : PageIndicatorPosition = .init(horizontal: .center,
                                                                        vertical: .bottom)
        let slideShowContentMode        : UIViewContentMode = .scaleAspectFill
        let slideShowActivityIndicator  : DefaultActivityIndicator = DefaultActivityIndicator()
        let pageControl                 : UIPageControl = UIPageControl(frame: .init(x: 0,
                                                                                     y: 0,
                                                                                     width: 500,
                                                                                     height: 10))
        let currentPageTintColor        : UIColor = Asset.mainGreen.color
        let pageIndicatorTintColor      : UIColor = Asset.secondaryGrayLight.color
        let slideShowBackColor          : UIColor = Asset.mainWhite.color
        let slideShowZoomEnabled        : Bool = true
        let slideShowLayerCornerRadius  : CGFloat = 12.0
        let placeHolderImage            : UIImage = Asset.icDefaultDrug.image
        let hitsTextColor               : UIColor = Asset.mainBlack.color
        let hitsTextFont                : UIFont = FontFamily.Inter.bold.font(size: 20)
        let hitsText                    : String = L10n.hits
    }
}

class HomeCVHeader: UICollectionReusableView {
    
    // MARK: UI Components
    private lazy var bannersCV: BannerCV = {
        let view = BannerCV()
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
    
    private lazy var instructionsCV: InstructionsCV = {
        let view = InstructionsCV()
        view._delegate = self
        return view
    }()
    
    private lazy var hitsTitle: UILabel = {
        let view = UILabel()
        view.font = appearance.hitsTextFont
        view.textColor = appearance.hitsTextColor
        view.text = appearance.hitsText
        return view
    }()
    
    // MARK: Properties
    public var delegate: HomeCVHeaderDelgate?
    private let appearance = Appearance()
    
    // MARK: Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Setup UI
extension HomeCVHeader {
    private func setupUI() {
        backgroundColor = appearance.backgroundColor
        addSubview(bannersCV)
        addSubview(instructionsCV)
        addSubview(pageControl)
        addSubview(hitsTitle)
    }
    
    private func setConstraints(_ hasSlideShow: Bool, _ isHaveInstructions: Bool, _ isHaveHits: Bool) {
        bannersCV.snp.remakeConstraints { (maker) in
            maker.top.equalTo(snp.top).offset(20)
            maker.right.left.equalToSuperview()
            maker.height.equalTo(hasSlideShow ? 230 : 0)
        }
        
        pageControl.isHidden = !hasSlideShow
        pageControl.snp.remakeConstraints { (maker) in
            maker.top.equalTo(bannersCV.snp.bottom).offset(12)
            maker.left.equalTo(snp.left).offset(20)
            maker.right.equalTo(snp.right).offset(-20)
            maker.height.equalTo(hasSlideShow ? 6 : 0)
        }
        
        instructionsCV.snp.remakeConstraints { (maker) in
            maker.top.equalTo(hasSlideShow ? pageControl.snp.bottom : snp.top).offset(20)
            maker.left.right.equalToSuperview()
            maker.height.equalTo(132.0)
            if !isHaveHits { maker.bottom.greaterThanOrEqualTo(snp.bottom) }
        }
        
        hitsTitle.alpha = isHaveHits ? 1 : 0
        hitsTitle.snp.remakeConstraints { (maker) in
            maker.top.equalTo(instructionsCV.snp.bottom).offset(20)
            maker.left.equalToSuperview().offset(20)
            maker.right.equalToSuperview().offset(-20)
            maker.bottom.greaterThanOrEqualTo(snp.bottom).offset(-12)
        }
        layoutIfNeeded()
    }
    
    func setupHeaderView(_ banners: [ImageBanner],
                         _ instructions: [Instruction],
                         _ isHaveHits: Bool) {
        hitsTitle.alpha = !isHaveHits ? 1 : 0
        
        setConstraints(!banners.isEmpty, !instructions.isEmpty, isHaveHits)
        pageControl.numberOfPages = banners.count
        bannersCV.setup(banners)
        instructionsCV.setInstructions(.init(instructions))
        
    }
}

extension HomeCVHeader: BannerCVDelegate {
    
    func openBannerByLink(_ link: String) {
        delegate?.openBannerByLink(link)
    }
    
    func changedIndexPath(_ indexPath: IndexPath) {
        pageControl.currentPage = indexPath.row
    }
}

extension HomeCVHeader: InstructionCVDelegate {
    
    func pushToMapPage() {
        delegate?.pushToMapPage()
    }
    
    func pushToDeliveryPage(_ programPolicy: PrivacyPolicy?) {
        delegate?.pushToDeliveryPage(programPolicy)
    }
    
    func pushToInstructionPage(_ programPolicy: PrivacyPolicy?) {
        delegate?.pushToInstructionPage(programPolicy)
    }
}
