//
//  MyProductsCVCellBlurView.swift
//  Infoapteka
//
//

import UIKit

protocol MyDrugCVCellBlurViewDelegate: AnyObject {
    func tappedOnMoreBtn()
}

// MARK: Appearance
extension MyDrugCVCellBlurView {
    struct Appearance {
        let cellCornerRadius: CGFloat = 16.0
        let cellBackgroundColor: UIColor = Asset.mainWhite.color
        let cellLayerMaskToBounds: Bool = true

        let moreBtnImage: UIImage = Asset.icProductEditButton.image

        let iconHeightWidht: CGFloat = 28.0
        let statusViewCornerRadius: CGFloat = 4.0
        let statusTextColor: UIColor = Asset.mainWhite.color
        let statusTextFont: UIFont = FontFamily.Inter.semiBold.font(size: 11)
    }
}

class MyDrugCVCellBlurView: UIView {

    private lazy var effectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.alpha = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var statusTitle = PaddingLbl(withInsets: 3.0, 3.0, 12.0, 12.0).then {
        $0.font = appearance.statusTextFont
        $0.textColor = appearance.statusTextColor
        $0.textAlignment = .center
        $0.layer.cornerRadius = 4.0
        $0.layer.masksToBounds = true
    }

    private lazy var moreButton: UIButton = {
        let view = UIButton()
        view.setImage(appearance.moreBtnImage, for: .normal)
        view.addTarget(self, action: #selector(didTappedMoreBtn), for: .touchUpInside)
        return view
    }()

    private var appearance = Appearance()
    weak var delegate: MyDrugCVCellBlurViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(effectView)
        effectView.snp.makeConstraints { (maker) in
            maker.right.left.bottom.top.equalToSuperview()
        }

        addSubview(statusTitle)
        statusTitle.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }

        addSubview(moreButton)
        moreButton.snp.makeConstraints { make in
            make.width.height.equalTo(appearance.iconHeightWidht)
            make.right.equalTo(snp.right).offset(-8.0)
            make.bottom.equalTo(snp.bottom).offset(-8.0)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setDrug(_ drug: Drug) {
        self.statusTitle.text = drug.status.title
        self.statusTitle.backgroundColor = drug.status.color
    }

    @objc private func didTappedMoreBtn() {
        moreButton.pulsate()
        delegate?.tappedOnMoreBtn()
    }
}
