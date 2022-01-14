//
//  DrugStoreDetailSlideCV.swift
//  Infoapteka
//
//  
//

import UIKit

protocol DrugStoreDetailSlideCVDelegate {
    func changedIndexPath(_ indexPath: IndexPath)
}

// MARK: Appearance
extension DrugStoreDetailSlideCV {
    struct Appearance {
        let backgroundColor: UIColor = Asset.mainWhite.color
    }
}

class DrugStoreDetailSlideCV: UICollectionView {
    
    // MARK: Properties
    public var _delegate: DrugStoreDetailSlideCVDelegate?
    private let appearnce = Appearance()
    private var images: [String] = [] {
        didSet {
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    
    // MARK: Initialize
    override init(frame: CGRect,
                  collectionViewLayout layout: UICollectionViewLayout) {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        super.init(frame: frame, collectionViewLayout: flowLayout)
        setupCV()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCV() {
        backgroundColor = appearnce.backgroundColor
        showsHorizontalScrollIndicator = false
        registerdequeueReusableCell(DrugStoreDetailCVCell.self)
        dataSource = self
        delegate = self
        showsHorizontalScrollIndicator = false
        isPagingEnabled = true
    }
    
    func setData(_ images: [String]) {
        self.images = images
    }
}

// MARK: UICollectionViewDataSource and Delegate
extension DrugStoreDetailSlideCV: UICollectionViewDataSource,
                                    UICollectionViewDelegate,
                                    UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(DrugStoreDetailCVCell.self, indexPath)
        cell.setupCell(images[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        .zero
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        .zero
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2),
                             y: (scrollView.frame.height / 2))
        if let ip = indexPathForItem(at: center) {
            _delegate?.changedIndexPath(ip)
        }
    }
}


// MARK: - Appearance of CollectionViewCell
extension DrugStoreDetailCVCell {
    struct Appearance {
        let backColor: UIColor = Asset.mainWhite.color
        let contentIVCorner: CGFloat = 12.0
        let ivContentMode: UIImageView.ContentMode = .scaleAspectFill
        let leftRightMargin: CGFloat = 20.0
    }
}

// MARK: UICollectionViewCell
class DrugStoreDetailCVCell: UICollectionViewCell {
    
    // MARK: UI Components
    private lazy var contentIV = UIImageView().then {
        $0.contentMode = appearance.ivContentMode
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
    }
    
    // MARK: Properties
    private let appearance = Appearance()
    
    // MARK: Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = appearance.backColor
        contentView.addSubview(contentIV)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentIV.layer.cornerRadius = appearance.contentIVCorner
        contentIV.snp.remakeConstraints { make in
            make.top.bottom.equalTo(contentView)
            make.right.equalTo(contentView.snp.right).offset(-appearance.leftRightMargin)
            make.left.equalTo(contentView.snp.left).offset(appearance.leftRightMargin)
        }
    }
    
    func setupCell(_ image: String?) {
        contentIV.load(image ?? "", Asset.icImagePlaceholder.image)
    }
}
