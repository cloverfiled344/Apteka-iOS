//
//  DrugSearchCVHeader.swift
//  Infoapteka
//
//

import UIKit

extension DrugSearchCVHeader {
    struct Appearance {
        let backgroundColor = Asset.mainWhite.color

        let titleLblFont    : UIFont = FontFamily.Inter.bold.font(size: 20)
        let titleLblColor   : UIColor = Asset.mainBlack.color
        let titleLblNumberOfLines   : Int = 2
        let titleLblLeftRightMargin : CGFloat = 20.0
        let titleLblTopMargin       : CGFloat = 12.0
    }
}

protocol DrugSearchCVHeaderDelegate {
    func didSelectFilterView()
    func didSelectGridTypeIV()
    func didSelectListTypeIV()
}

class DrugSearchCVHeader: UICollectionReusableView {

    lazy private var ownerProfileInfoView: OwnerProfileInfoView = {
        let ownerProfileInfoView = OwnerProfileInfoView()
        return ownerProfileInfoView
    }()

    lazy private var titleLbl: UILabel = {
        let view = UILabel()
        view.font           = appearance.titleLblFont
        view.textColor      = appearance.titleLblColor
        view.numberOfLines  = appearance.titleLblNumberOfLines
        return view
    }()

    lazy private var filterView: FilterView = {
        let view = FilterView()
        view.delegate = self
        return view
    }()

    private let appearance = Appearance()
    var delegate: DrugSearchCVHeaderDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(titleLbl)
        addSubview(filterView)
        addSubview(ownerProfileInfoView)
    }

    func setup(_ title: String,
               _ ordering: SearchFilter?,
               _ collectionType: CollectionType,
               _ profile: Profile?) {

        titleLbl.text = title
        filterView.setup(ordering, collectionType)
        ownerProfileInfoView.setup(profile)

        let profileIsHave: Bool = profile != nil
        ownerProfileInfoView.isHidden = !profileIsHave
        ownerProfileInfoView.snp.remakeConstraints { make in
            make.top.equalTo(snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(profileIsHave ? 145.0 : 0)
        }

        titleLbl.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(appearance.titleLblLeftRightMargin)
            make.top.equalTo(profileIsHave ? ownerProfileInfoView.snp.bottom : snp.top).offset(appearance.titleLblLeftRightMargin)
            make.right.equalToSuperview().offset(-appearance.titleLblLeftRightMargin)
        }

        filterView.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(titleLbl.snp.bottom).offset(12)
            make.height.equalTo(48)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DrugSearchCVHeader: FilterViewDelegate {
    func didSelectFilterView() {
        delegate?.didSelectFilterView()
    }

    func didSelectGridTypeIV() {
        delegate?.didSelectGridTypeIV()
    }

    func didSelectListTypeIV() {
        delegate?.didSelectListTypeIV()
    }
}

protocol FilterViewDelegate {
    func didSelectFilterView()
    func didSelectGridTypeIV()
    func didSelectListTypeIV()
}

extension FilterView {
    struct Appearance {
        let backgroundColor : UIColor = Asset.mainWhite.color
        let cornerRadius    : CGFloat = 12.0

        let titleLblFont    : UIFont = FontFamily.Inter.regular.font(size: 13)
        let titleLblColor   : UIColor = Asset.secondaryGray.color
        let titleLblLeftRightMargin : CGFloat = 16.0
        let titleLblTopMargin       : CGFloat = 12.0

        let icArrowIVContentMode    : UIImageView.ContentMode = .scaleAspectFit
        let icArrowIVClipsToBounds  : Bool = true
        let icActiveGridImage   : UIImage = Asset.icActiveGrid.image
        let icNotActiveGridImage: UIImage = Asset.icActiveGrid.image
            .withTintColor(Asset.secondaryGray.color)
        let icNotActiveListImage: UIImage = Asset.icNotActiveList.image
        let icActiveListImage   : UIImage = Asset.icNotActiveList.image.withTintColor(Asset.mainGreen.color)
    }
}

class FilterView: UIView {

    lazy private var filterOrderView: FilterOrderView = {
        let view = FilterOrderView()
        return view
    }()

    lazy private var titleLbl: UILabel = {
        let view = UILabel()
        view.font           = appearance.titleLblFont
        view.textColor      = appearance.titleLblColor
        view.text           = "Вид:"
        view.textAlignment = .right
        return view
    }()

    private lazy var gridTypeIV: UIImageView = {
        let view = UIImageView()
        view.image          = appearance.icActiveGridImage
        view.clipsToBounds  = appearance.icArrowIVClipsToBounds
        view.contentMode    = appearance.icArrowIVContentMode
        return view
    }()

    private lazy var listTypeIV: UIImageView = {
        let view = UIImageView()
        view.image          = appearance.icNotActiveListImage
        view.clipsToBounds  = appearance.icArrowIVClipsToBounds
        view.contentMode    = appearance.icArrowIVContentMode
        return view
    }()

    private let appearance = Appearance()
    var delegate: FilterViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor     = appearance.backgroundColor
        layer.cornerRadius  = appearance.cornerRadius
        layer.masksToBounds = true

        addSubview(gridTypeIV)
        let gridTypeIVTap = UITapGestureRecognizer(target: self,
                                                        action: #selector(didSelectGridTypeIV))
        gridTypeIV.isUserInteractionEnabled = true
        gridTypeIV.addGestureRecognizer(gridTypeIVTap)
        gridTypeIV.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(20)
        }

        addSubview(listTypeIV)
        let listTypeIVTap = UITapGestureRecognizer(target: self,
                                                        action: #selector(didSelectListTypeIV))
        listTypeIV.isUserInteractionEnabled = true
        listTypeIV.addGestureRecognizer(listTypeIVTap)
        listTypeIV.snp.makeConstraints { make in
            make.right.equalTo(gridTypeIV.snp.left).offset(-8)
            make.centerY.equalTo(gridTypeIV.snp.centerY)
            make.height.width.equalTo(20)
        }

        addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.right.equalTo(listTypeIV.snp.left).offset(-8)
            make.centerY.equalTo(gridTypeIV.snp.centerY)
            make.left.equalTo(snp.centerX)
        }

        addSubview(filterOrderView)
        let filterOrderViewTap = UITapGestureRecognizer(target: self,
                                                        action: #selector(didSelectFilterView))
        filterOrderView.isUserInteractionEnabled = true
        filterOrderView.addGestureRecognizer(filterOrderViewTap)
        filterOrderView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8)
            make.height.equalTo(32)
            make.centerY.equalTo(gridTypeIV.snp.centerY)
            make.right.equalTo(snp.centerX).offset(-8)
        }
    }

    func setup(_ searchFilter: SearchFilter?, _ collectionType: CollectionType) {
        filterOrderView.setup(searchFilter)
        switch collectionType {
        case .grid:
            gridTypeIV.image = appearance.icActiveGridImage
            listTypeIV.image = appearance.icNotActiveListImage
        case .list:
            gridTypeIV.image = appearance.icNotActiveGridImage
            listTypeIV.image = appearance.icActiveListImage
        }
    }

    @objc private func didSelectGridTypeIV() {
        gridTypeIV.pulsate()
        delegate?.didSelectGridTypeIV()
    }

    @objc private func didSelectListTypeIV() {
        listTypeIV.pulsate()
        delegate?.didSelectListTypeIV()
    }

    @objc private func didSelectFilterView() {
        filterOrderView.pulsate()
        delegate?.didSelectFilterView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension FilterOrderView {
    struct Appearance {
        let backgroundColor : UIColor = Asset.mainWhite.color
        let borderWidth     : CGFloat = 1
        let borderColor     : CGColor = Asset.secondaryGray.color.cgColor
        let cornerRadius    : CGFloat = 12.0

        let titleLblFont    : UIFont = FontFamily.Inter.regular.font(size: 13)
        let titleLblColor   : UIColor = Asset.darkBlue.color
        let titleLblNumberOfLines   : Int = 2
        let titleLblRightMargin     : CGFloat = 16.0

        let arrowImageHeightWidth: CGFloat = 16.0
        let arrowDownImage: UIImage = Asset.icArrowDown.image
        let arrowTopImage: UIImage = Asset.icTopArrow.image

        let icArrowIVContentMode: UIImageView.ContentMode = .scaleAspectFit
        let icArrowIVClipsToBounds: Bool = true
    }
}

class FilterOrderView: UIView {

    private lazy var contentView: UIView = {
        let view = UIView()
        view.addSubview(titleLbl)
        view.addSubview(icArrowIV)
        return view
    }()

    lazy private var titleLbl: UILabel = {
        let view = UILabel()
        view.font           = appearance.titleLblFont
        view.textColor      = appearance.titleLblColor
        view.numberOfLines  = appearance.titleLblNumberOfLines
        return view
    }()

    private lazy var icArrowIV: UIImageView = {
        let view = UIImageView()
        view.image          = appearance.arrowDownImage
        view.clipsToBounds  = appearance.icArrowIVClipsToBounds
        view.contentMode    = appearance.icArrowIVContentMode
        return view
    }()

    private let appearance = Appearance()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor     = appearance.backgroundColor
        layer.borderWidth   = appearance.borderWidth
        layer.borderColor   = appearance.borderColor
        layer.cornerRadius  = appearance.cornerRadius

        addSubview(contentView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.snp.remakeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(frame.size.height)
        }

        titleLbl.snp.remakeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.right.equalTo(icArrowIV.snp.left).offset(-10)
        }

        icArrowIV.snp.remakeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalTo(titleLbl.snp.centerY)
            make.width.height.equalTo(appearance.arrowImageHeightWidth)
        }
    }

    func setup(_ searchFilter: SearchFilter?) {
        titleLbl.text = searchFilter?.filterType?.rawValue ?? L10n.sort
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
