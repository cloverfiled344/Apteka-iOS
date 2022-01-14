//
//  HorizontalImgsCVCell.swift
//  Infoapteka
//
//

import UIKit
import ImageSlideshow
import ImageSlideshowSDWebImage

protocol HorizontalImgsCVCellDelegate {
    func didTappedRemoveBtn(_ certificate: Certificate)
    func didTapOnSlideshow(_ imageSlideshow: ImageSlideshow)
}

extension HorizontalImgsCVCell {
    struct Appearance {
        let backgroundColorWithImage: UIColor = Asset.mainRed.color
        let backgroundColorWithoutImage: UIColor = Asset.mainWhite.color

        let removeBtnImage: UIImage = Asset.icRemove.image

        let infoLblTitleTextColor: UIColor = Asset.mainBlack.color
        let infoLblTitleFont: UIFont = FontFamily.Inter.semiBold.font(size: 12)

        let infoLblSubtitleTextColor: UIColor = Asset.secondaryGray.color
        let infoLblSubtitleFont: UIFont = FontFamily.Inter.regular.font(size: 12)
        let infoLblBottomMargin: CGFloat = 21.0
    }
}

class HorizontalImgsCVCell: UICollectionViewCell {

    private lazy var slideshow: ImageSlideshow = {
        let view = ImageSlideshow()
        view.delegate = self
        view.backgroundColor = Asset.secondaryLight.color
        view.zoomEnabled = true
        view.layer.cornerRadius = 8.0
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var removeBtn: UIButton = {
        let view = UIButton()
        view.backgroundColor = .clear
        view.setImage(appearance.removeBtnImage, for: .normal)
        view.addTarget(self, action: #selector(didTappedRemoveBtn), for: .touchUpInside)
        return view
    }()

    private lazy var infoLbl: UILabel = {
        let view = UILabel()
        return view
    }()

    private let appearance = Appearance()

    var certificate: Certificate? {
        didSet {
            guard let certificate = certificate else { return }
            updateView(certificate)
        }
    }

    var delegate: HorizontalImgsCVCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    func setupCertificate(_ certificate: Certificate?) {
        self.certificate = certificate
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension HorizontalImgsCVCell {
    func setupUI() {
        self.addSubview(self.infoLbl)
        self.infoLbl.snp.makeConstraints { maker in
            maker.left.bottom.right.equalToSuperview()
        }

        self.addSubview(self.slideshow)
        self.slideshow.snp.makeConstraints { maker in
            maker.top.left.right.equalToSuperview()
            maker.bottom.equalTo(self.infoLbl.snp.top).offset(-12)
        }

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTapOnSlideshow))
        self.slideshow.addGestureRecognizer(recognizer)

        self.addSubview(self.removeBtn)
        self.removeBtn.snp.makeConstraints { maker in
            maker.right.equalToSuperview().offset(-6)
            maker.top.equalToSuperview().offset(6)
            maker.height.width.equalTo(20)
        }
    }
}

private extension HorizontalImgsCVCell {
    @objc func didTapOnSlideshow() {
        guard !self.slideshow.images.isEmpty else { return }
        self.delegate?.didTapOnSlideshow(slideshow)
    }

    @objc private func didTappedRemoveBtn() {
        self.removeBtn.pulsate(sender: self.removeBtn)
        guard let certificate = self.certificate else { return }
        self.delegate?.didTappedRemoveBtn(certificate)
    }
}

private extension HorizontalImgsCVCell {
    func updateView(_ certificate: Certificate) {
        setImageSlideshow(certificate)
    }

    func setImageSlideshow(_ certificate: Certificate) {
        self.slideshow.setImageInputs([])
        if let url = certificate.url {
            setImage(certificate, url)
        } else if let image = certificate.image {
            setSource(image)
            setInfoLbl(certificate.image?.title ?? "", certificate.image?.size ?? 0)
        }
    }

    func setImage(_ certificate: Certificate, _ url: String) {
        let iv = UIImageView()
        iv.sd_setImage(with: .init(string: url),
                       placeholderImage: .init(),
                       options: .progressiveLoad, progress: nil) { image, err, type, url in
            let input: ImageSource = ImageSource(image: iv.image ?? Asset.icAvatarPlaceholder.image)
            self.slideshow.setImageInputs([input])
            self.slideshow.reloadInputViews()
            self.setInfoLbl(url?.lastPathComponent ?? "", iv.image?.sizeInMB ?? 0)
        }
    }

    func setSource(_ image: Image) {
        DispatchQueue.main.async {
            self.slideshow.setImageInputs([ImageSource(image: image.image ?? .init())])
            self.slideshow.reloadInputViews()
        }
    }

    func setInfoLbl(_ imageName: String,
                    _ imageSize: Float) {
        createAttributedTextForInfoLbl(imageName, imageSize)
    }

    func createAttributedTextForInfoLbl(_ imageName: String,
                                        _ imageSize: Float) {
        let title = "\(String(imageName.prefix(9)))\(String(imageName.suffix(4)))"
        let titleAtributes: [NSAttributedString.Key : Any] = [
            .font: appearance.infoLblTitleFont,
            .foregroundColor: appearance.infoLblTitleTextColor]
        let attributedText = NSMutableAttributedString(string: title,
                                                       attributes: titleAtributes)

        addAttributedTextForInfoLbl(imageSize, attributedText)
    }

    func addAttributedTextForInfoLbl(_ imageSize: Float,
                                     _ attributedText: NSMutableAttributedString) {
        let subtitle = String("\nРазмер: \(String(format: "%.1f", imageSize)) мб".prefix(16))
        let subtitleAtributes: [NSAttributedString.Key : Any] = [.font: appearance.infoLblSubtitleFont,
                                                                 .foregroundColor: appearance.infoLblSubtitleTextColor]
        attributedText.append(.init(string: subtitle, attributes: subtitleAtributes))
        self.infoLbl.numberOfLines = 2
        self.infoLbl.attributedText = attributedText
    }
}

extension HorizontalImgsCVCell: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {}
}
