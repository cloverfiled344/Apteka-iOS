//
//  HorizontalImgsCV.swift
//  Infoapteka
//
//

import UIKit
import ImageSlideshow

protocol HorizontalImgsCVDelegate {
    func removeImage(_ certificate: Certificate?)
    func didTapOnSlideshow(_ imageSlideshow: ImageSlideshow)
}

extension HorizontalImgsCV {
    struct Appearance {
        let backgroundColor: UIColor = Asset.mainWhite.color
        let minimumLineSpacingForSectionAt: CGFloat = 10.0
        let sizeForItemAt: CGSize = .init(width: 64, height: 64)
    }
}

class HorizontalImgsCV: UICollectionView {

    private let appearance = Appearance()
    private var certificate: [Certificate] = []
    var cvDelegate: HorizontalImgsCVDelegate?

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        self.dataSource = self
        self.delegate = self
        self.showsHorizontalScrollIndicator = false
        self.isPagingEnabled = false
        self.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        self.backgroundColor = Asset.mainWhite.color
        self.registerdequeueReusableCell(HorizontalImgsCVCell.self)
    }

    private func reloadImages() {
        DispatchQueue.main.async { self.reloadData() }
    }

    func setImages(_ certificate: [Certificate]) {
        self.certificate = certificate
        self.reloadData()
    }

    func appendImages(_ certificate: [Certificate]) {
        self.certificate.append(contentsOf: certificate)
        self.reloadData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HorizontalImgsCV: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        appearance.minimumLineSpacingForSectionAt
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: 100, height: collectionView.bounds.size.height)
    }
}

extension HorizontalImgsCV: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.certificate.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(HorizontalImgsCVCell.self, indexPath)
        cell.delegate = self
        cell.setupCertificate(self.certificate.count > indexPath.row ? self.certificate[indexPath.row] : nil)
        return cell
    }
}

extension HorizontalImgsCV: HorizontalImgsCVCellDelegate {
    func didTapOnSlideshow(_ imageSlideshow: ImageSlideshow) {
        self.cvDelegate?.didTapOnSlideshow(imageSlideshow)
    }

    func didTappedRemoveBtn(_ certificate: Certificate) {
        self.cvDelegate?.removeImage(certificate)
    }
}
