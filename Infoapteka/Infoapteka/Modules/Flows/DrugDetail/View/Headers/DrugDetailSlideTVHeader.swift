//
//  DrugDetailSlideTVHeader.swift
//  Infoapteka
//
//  
//

import UIKit
import ImageSlideshow
import ImageSlideshowSDWebImage

// MARK: Appearance
extension DrugDetailSlideTVHeader {
    struct Appearance {
        let backgroundColor: UIColor = Asset.mainWhite.color
        let slideShowIndicatorPosition: PageIndicatorPosition = .init(horizontal: .center, vertical: .customBottom(padding: 5))
        let slideShowContentMode: UIViewContentMode = .scaleAspectFill
        let slideShowActivityIndicator: DefaultActivityIndicator = DefaultActivityIndicator()
        let pageControl: UIPageControl = UIPageControl(frame: .init(x: 0, y: 0, width: 500, height: 8))
        let currentPageTintColor: UIColor = Asset.mainGreen.color
        let pageIndicatorTintColor: UIColor = Asset.secondaryGrayLight.color
        let slideShowBackColor: UIColor = Asset.mainWhite.color
        let slideShowZoomEnabled: Bool = true
        let placeHolderImage: UIImage = Asset.icAvatarPlaceholder.image
        let slideShowHeight: CGFloat = Constants.screenWidth
    }
}


class DrugDetailSlideTVHeader: UITableViewHeaderFooterView {
    
    // MARK: UI Component
    private lazy var contentIV: ImageSlideshow = {
        let view = ImageSlideshow()
        view.pageIndicatorPosition = appearance.slideShowIndicatorPosition
        view.activityIndicator = appearance.slideShowActivityIndicator
        view.contentScaleMode = appearance.slideShowContentMode
        let pi = appearance.pageControl
        pi.currentPageIndicatorTintColor = appearance.currentPageTintColor
        pi.pageIndicatorTintColor = appearance.pageIndicatorTintColor
        view.pageIndicator = pi
        view.backgroundColor = appearance.slideShowBackColor
        view.zoomEnabled = appearance.slideShowZoomEnabled
        return view
    }()
    
    // MARK: Properties
    public var root: UIViewController?
    private let appearance = Appearance()
    
    // MARK: Initialize
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = appearance.backgroundColor
        contentView.addSubview(contentIV)
        setupGestureOnSlideShow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup Data
    fileprivate func setupSlideShow(_ images: [DrugDetailImage], _ sdWebImageSource: inout [SDWebImageSource]) {
        images.forEach {
            guard let urlStr = URL(string: $0.image ?? "") else { return }
            sdWebImageSource.append(.init(url: urlStr, placeholder: appearance.placeHolderImage))
        }
        contentIV.slideshowInterval = Double(sdWebImageSource.count)
        contentIV.setImageInputs(sdWebImageSource)
        contentIV.reloadInputViews()
    }
    
    func setImages(_ images: [DrugDetailImage]) {
        var sdWebImageSource: [SDWebImageSource] = []
        if images.isEmpty {
            contentIV.snp.removeConstraints()
        }
        else {
            setupUI()
            setupSlideShow(images, &sdWebImageSource)
        }
    }
}

// MARK: Setup UI
extension DrugDetailSlideTVHeader {
    
    private func setupUI() {
        contentIV.snp.remakeConstraints { (maker) in
            maker.height.equalTo(appearance.slideShowHeight)
            maker.top.left.right.equalTo(contentView)
            maker.bottom.equalTo(contentView.snp.bottom).offset(-12)
        }
    }
    
    private func setupGestureOnSlideShow() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTappedOnSlideShow))
        self.contentIV.addGestureRecognizer(recognizer)
    }
    
    @objc private func didTappedOnSlideShow() {
        guard !self.contentIV.images.isEmpty else { return }
        let fullScreenVC = contentIV.presentFullScreenController(from: self.root ?? UIViewController())
        fullScreenVC.slideshow.activityIndicator = DefaultActivityIndicator(style: .medium, color: nil)
    }
}
