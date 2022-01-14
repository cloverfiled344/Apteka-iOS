//
//  DrugImagesTVCell.swift
//  Infoapteka
//
//

import UIKit
import ImageSlideshow

protocol DrugImagesTVCellDelegate {
    func openPicker()
    func removeImage(_ certificate: Certificate?)
    func didTapOnSlideshow(_ imageSlideshow: ImageSlideshow)
}

// MARK: -- Appearance
extension DrugImagesTVCell {
    struct Appearance {
        let backgroundColor: UIColor = Asset.mainWhite.color

        let addCertificateIVWidth: CGFloat = Constants.screenWidth - 16
        let addCertificateIVImage: UIImage = Asset.icAddCertificate.image

        let certificatesCVTopBottomMargin: CGFloat = 16.0

        let infoLblTextColor: UIColor = Asset.secondaryGray.color
        let infoLblFont: UIFont = FontFamily.Inter.regular.font(size: 13)
        let infoLblTextAlignment: NSTextAlignment = .center
        let infoLblBottomMargin : CGFloat = 21.0
        let infoLblText: String = L10n.uploadImageInfo
    }
}

class DrugImagesTVCell: UITableViewCell {

    // MARK: -- UIProperties
    private lazy var addCertificateIV: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.image = appearance.addCertificateIVImage
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(didTappedAddCertificates))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
        return view
    }()

    private lazy var certificatesCV: HorizontalImgsCV = {
        let view = HorizontalImgsCV()
        view.cvDelegate = self
        return view
    }()

    private lazy var infoLbl: UILabel = {
        let view = UILabel()
        view.textColor = appearance.infoLblTextColor
        view.font = appearance.infoLblFont
        view.textAlignment = appearance.infoLblTextAlignment
        view.text = appearance.infoLblText
        view.numberOfLines = 2
        return view
    }()

    // MARK: -- Propeerties
    private var appearance = Appearance()
    private var certificate: [Certificate] = [] {
        didSet {
            certificatesCV.setImages(certificate)
            configureCertificatesCV()
        }
    }
    var delegate: DrugImagesTVCellDelegate?

    // MARK: -- init
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        contentView.addSubview(addCertificateIV)
        contentView.addSubview(certificatesCV)
        contentView.addSubview(infoLbl)
    }

    // MARK: -- public Methods
    func setImages(_ certificate: [Certificate]) {
        self.certificate = certificate
    }

    // MARK: -- making
    fileprivate func configureCertificatesCV() {
        certificatesCV.snp.remakeConstraints { make in
            make.top.equalTo(addCertificateIV.snp.bottom).offset(appearance.certificatesCVTopBottomMargin)
            make.width.equalTo(appearance.addCertificateIVWidth)
            make.height.equalTo(!certificate.isEmpty ? appearance.addCertificateIVWidth * 0.4 : 0)
            make.centerX.equalToSuperview()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        addCertificateIV.snp.remakeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.width.equalTo(appearance.addCertificateIVWidth)
            make.height.equalTo(appearance.addCertificateIVWidth * 0.5)
            make.centerX.equalToSuperview()
        }

        configureCertificatesCV()

        infoLbl.snp.remakeConstraints { make in
            make.top.equalTo(certificatesCV.snp.bottom).offset(appearance.certificatesCVTopBottomMargin)
            make.bottom.equalTo(contentView.snp.bottom).offset(-appearance.infoLblBottomMargin)
            make.width.equalTo(appearance.addCertificateIVWidth)
            make.centerX.equalToSuperview()
        }
    }

    @objc private func didTappedAddCertificates() {
        delegate?.openPicker()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DrugImagesTVCell: HorizontalImgsCVDelegate {
    func didTapOnSlideshow(_ imageSlideshow: ImageSlideshow) {
        delegate?.didTapOnSlideshow(imageSlideshow)
    }

    func removeImage(_ certificate: Certificate?) {
        delegate?.removeImage(certificate)
    }
}
