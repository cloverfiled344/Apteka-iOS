//
//  CityCell.swift
//  Infoapteka
//
//

import UIKit

// MARK: Appearance
extension CityCell {
    struct Appearance {
        let icArrowRightImage           : UIImage = Asset.icArrowRight.image
        let icArrowRightIVContentMode   : UIImageView.ContentMode = .scaleAspectFit
        let icArrowRightIVClipsToBounds : Bool = true
        let icArrowRightIVRightMargin   : CGFloat = 20.0
        let icArrowRightIVWidth         : CGFloat = 24.0

        let titleLblTextColor: UIColor = Asset.mainBlack.color
        let titleLblFont: UIFont = FontFamily.Inter.regular.font(size: 14.0)
        let titleLblLeftMargin: CGFloat = 20.0
        let titleLblRightMargin: CGFloat = 12.0
    }
}

class CityCell: UITableViewCell {

    //MARK: -- UIProperties
    lazy private var titleLbl: UILabel = { UILabel() }()
    private lazy var icArrowRightIV: UIImageView = {
        let view = UIImageView()
        view.image          = appearance.icArrowRightImage
        view.clipsToBounds  = appearance.icArrowRightIVClipsToBounds
        view.contentMode    = appearance.icArrowRightIVContentMode
        return view
    }()

    private let appearance = Appearance()
    private var city: City? {
        didSet {
            guard let city = city else { return }
            titleLbl.text        = city.title
            icArrowRightIV.alpha = city.districts.isEmpty ? 0 : 1
        }
    }
    //MARK: -- init
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)

        contentView.addSubview(icArrowRightIV)
        contentView.addSubview(titleLbl)

        separatorInset = .init(top: 0, left: 20, bottom: 0, right: 20)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        icArrowRightIV.snp.makeConstraints { make in
            make.right.equalTo(snp.right).offset(-appearance.icArrowRightIVRightMargin)
            make.height.width.equalTo(appearance.icArrowRightIVWidth)
            make.centerY.equalTo(snp.centerY)
        }

        titleLbl.snp.remakeConstraints { make in
            make.left.equalTo(contentView.snp.left).offset(appearance.titleLblLeftMargin)
            make.right.equalTo(icArrowRightIV.snp.left).offset(-appearance.titleLblRightMargin)
            make.centerY.equalTo(icArrowRightIV.snp.centerY)
        }
    }

    //MARK: -- public methods
    func setCity(_ city: City?) {
        self.city = city
    }

    //MARK: -- deinit
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
