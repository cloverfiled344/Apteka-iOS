//
//  BannerCV.swift
//  Infoapteka
//
//  
//

import UIKit

protocol BannerCVDelegate {
    func changedIndexPath(_ indexPath: IndexPath)
    func openBannerByLink(_ link: String)
}

extension BannerCV {
    struct Appearance {
        let backgroundColor: UIColor = Asset.backgroundGray.color
    }
}

class BannerCV: UICollectionView {
    
    // MARK: Properties
    private var banners: [ImageBanner] = [] {
        didSet {
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    private let appearance = Appearance()
    var _delegate: BannerCVDelegate?
    
    // MARK: Initialize
    override init(frame: CGRect,
                  collectionViewLayout layout: UICollectionViewLayout) {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        super.init(frame: frame, collectionViewLayout: flowLayout)
        setupUI()
    }

    fileprivate func setupUI() {
        backgroundColor = appearance.backgroundColor
        delegate = self
        dataSource = self
        showsHorizontalScrollIndicator = false
        registerdequeueReusableCell(BannerCVCell.self)
        isPagingEnabled = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(_ banners: [ImageBanner]) {
        self.banners = banners
    }
}

extension BannerCV: UICollectionViewDataSource,
                    UICollectionViewDelegate,
                    UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return banners.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(BannerCVCell.self, indexPath)
        cell.setupImage(banners[indexPath.row].image)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let links = banners.compactMap { $0.link }
        _delegate?.openBannerByLink(links[indexPath.row])
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.bounds.size.width, height: banners.isEmpty ? 0 : 230)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2),
                             y: (scrollView.frame.height / 2))
        if let ip = indexPathForItem(at: center) {
            _delegate?.changedIndexPath(ip)
        }
    }
}
