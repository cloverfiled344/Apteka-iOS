//
//  CertificatesCell.swift
//  Infoapteka
//
//

import UIKit
import ImageSlideshow

protocol CertificatesCellDelegate {
    func openPicker()
    func removeImage(_ certificate: Certificate?)
    func didTapOnSlideshow(_ imageSlideshow: ImageSlideshow)
}

// MARK: -- Appearance
extension CertificatesCell {
    struct Appearance {
        let backgroundColor: UIColor = Asset.mainWhite.color

        let addCertificateIVWidth: CGFloat = Constants.screenWidth - 40

        let certificatesCVTopBottomMargin: CGFloat = 16.0

        let infoLblTextColor: UIColor = Asset.secondaryGray.color
        let infoLblFont: UIFont = FontFamily.Inter.regular.font(size: 13)
        let infoLblTextAlignment: NSTextAlignment = .center
        let infoLblBottomMargin : CGFloat = 21.0
        let infoLblText: String = L10n.uploadImageInfo
    }
}

class CertificatesCell: UITableViewCell {

    // MARK: -- UIProperties
    private lazy var addCertificateIV: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
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
        view.numberOfLines = 0
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
    var delegate: CertificatesCellDelegate?

    // MARK: -- init
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        contentView.addSubview(addCertificateIV)
        contentView.addSubview(certificatesCV)
        contentView.addSubview(infoLbl)

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

    fileprivate func configureCertificatesCV() {
        certificatesCV.snp.remakeConstraints { make in
            make.top.equalTo(addCertificateIV.snp.bottom).offset(appearance.certificatesCVTopBottomMargin)
            make.width.equalTo(appearance.addCertificateIVWidth)
            make.height.equalTo(!certificate.isEmpty ? appearance.addCertificateIVWidth * 0.4 : 0)
            make.centerX.equalToSuperview()
        }
    }

    // MARK: -- public Methods
    func setup(_ certificate: [Certificate], _ icon: UIImage, _ subtitle: String) {
        self.certificate = certificate
        self.addCertificateIV.image = icon
        self.infoLbl.text = subtitle
    }

    @objc private func didTappedAddCertificates() {
        delegate?.openPicker()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CertificatesCell: HorizontalImgsCVDelegate {
    func didTapOnSlideshow(_ imageSlideshow: ImageSlideshow) {
        delegate?.didTapOnSlideshow(imageSlideshow)
    }

    func removeImage(_ certificate: Certificate?) {
        delegate?.removeImage(certificate)
    }
}
