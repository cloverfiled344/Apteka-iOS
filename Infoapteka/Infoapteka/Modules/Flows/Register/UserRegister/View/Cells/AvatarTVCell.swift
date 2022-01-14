//
//  AvatarTVCell.swift
//  Infoapteka
//
//

import UIKit

protocol AvatarTVCellDelegate {
    func didTappedAvatarEditBtn(_ avatarIsHave: Bool)
}

// MARK: Appearance
extension AvatarTVCell {
    struct Appearance {
        let backgroundColor: UIColor = Asset.mainWhite.color
        let avatarIVBorderWidth: CGFloat = 4.0
        let avatarIVImage: UIImage = Asset.icAvatarPlaceholder.image
        let avatarIVBorderColor: CGColor = Asset.light.color.cgColor
        let avatarIVContentMode: UIImageView.ContentMode = .scaleAspectFill
        let avatarIVClipsToBounds: Bool = true
        let avatarIVTopButtomMargin: CGFloat = 32.0

        let avatarEditBtnImage: UIImage = Asset.icEditProfile.image
        let avatarEditBtnClipsToBounds: Bool = true
    }
}

class AvatarTVCell: UITableViewCell {

    lazy private var avatarIV: UIImageView = {
        let view = UIImageView()
        view.layer.borderWidth = appearance.avatarIVBorderWidth
        view.layer.borderColor = appearance.avatarIVBorderColor
        view.contentMode   = appearance.avatarIVContentMode
        view.clipsToBounds = appearance.avatarIVClipsToBounds
        view.image = appearance.avatarIVImage
        view.layer.masksToBounds = true
        return view
    }()

    lazy private var avatarEditBtn: UIButton = {
        let view = UIButton()
        view.addTarget(self, action: #selector(didTappedAvatarEditBtn), for: .touchUpInside)
        view.setImage(appearance.avatarEditBtnImage, for: .normal)
        view.clipsToBounds = appearance.avatarEditBtnClipsToBounds
        return view
    }()

    private let appearance = Appearance()
    var delegate: AvatarTVCellDelegate?
    var avatar: Any? {
        didSet {
            if let image = (avatar as? Image) {
                self.avatarIV.image = image.image
            } else if let avatar = (avatar as? String) {
                self.avatarIV.load(avatar, appearance.avatarIVImage)
            } else {
                self.avatarIV.image = appearance.avatarIVImage
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        contentView.addSubview(avatarIV)
        contentView.addSubview(avatarEditBtn)

        let width: CGFloat = frame.width
        let avatarHeight: Int = Int(width * 0.43)
        avatarIV.layer.cornerRadius = CGFloat(avatarHeight/2)
        avatarIV.snp.remakeConstraints { (maker) in
            maker.centerX.equalTo(contentView.snp.centerX)
            maker.width.height.equalTo(avatarHeight)
            maker.top.equalTo(contentView.snp.top).offset(appearance.avatarIVTopButtomMargin)
            maker.bottom.equalTo(contentView.snp.bottom).offset(-appearance.avatarIVTopButtomMargin)
        }

        let avatarEditBtnHeight: CGFloat = CGFloat(avatarHeight) * 0.2
        avatarEditBtn.layer.cornerRadius = avatarEditBtnHeight/2
        avatarEditBtn.snp.remakeConstraints { (maker) in
            maker.right.bottom.equalTo(avatarIV).offset(-9)
            maker.height.width.equalTo(avatarEditBtnHeight)
        }
    }

    func setup(_ avatar: Any?) {
        self.avatar = avatar
    }

    @objc private func didTappedAvatarEditBtn() {
        self.avatarEditBtn.pulsate()
        self.delegate?.didTappedAvatarEditBtn(self.avatar != nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
