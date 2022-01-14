//
//  PlaceAnOrderView.swift
//  Infoapteka
//
//

import UIKit

protocol PlaceAnOrderViewDelegate {
    func didTappedSubmitBtn()
}

// MARK: -- Appearance
extension PlaceAnOrderView {
    struct Appearance {
        let backgroundColor: UIColor = Asset.mainWhite.color

        let centerViewCornerRadius: CGFloat = 16.0
        let maskedCorners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}

class PlaceAnOrderView: UIView {

    lazy private var submitBtn: UIButton = {
        let view = UIButton()
        view.backgroundColor = Asset.mainGreen.color
        view.layer.cornerRadius = 12.0
        view.titleLabel?.font = FontFamily.Inter.regular.font(size: 14)
        view.titleLabel?.textColor = Asset.mainWhite.color
        view.setTitle("Оформить заказ", for: .normal)
        view.addTarget(self, action: #selector(didTappedSubmitBtn), for: .touchUpInside)
        return view
    }()

    lazy private var bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = Asset.secondaryLight.color
        return view
    }()

    private var appearance = Appearance()
    var delegate: PlaceAnOrderViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor     = appearance.backgroundColor
        layer.cornerRadius  = appearance.centerViewCornerRadius
        layer.maskedCorners = appearance.maskedCorners
        layer.shadowRadius = 16
        layer.shadowOffset = CGSize(width: 0, height: -3)

        addTopShadow(shadowColor: Asset.mainBlack.color.withAlphaComponent(0.15),
                     shadowOpacity: 1,
                     shadowRadius: 16,
                     offset: CGSize(width: 8.0,
                                    height : 0.0))

        addSubview(bottomLine)
        addSubview(submitBtn)

        bottomLine.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20.0)
            make.right.equalToSuperview().offset(-20.0)
            make.height.equalTo(1.0)
            make.bottom.equalToSuperview()
        }

        submitBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20.0)
            make.right.equalToSuperview().offset(-20.0)
            make.height.equalTo(46.0)
            make.bottom.lessThanOrEqualTo(bottomLine.snp.top).offset(-16.0)
            make.top.equalToSuperview().offset(20.0)
        }
    }
    
    func setupSubmitBtnStyle(_ title: String, _ image: UIImage) {
        submitBtn.setImage(image, for: .normal)
        submitBtn.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 10)
        submitBtn.setTitle(title, for: .normal)
        submitBtn.setTitleColor(Asset.mainWhite.color, for: .normal)
    }

    @objc private func didTappedSubmitBtn() {
        submitBtn.pulsate()
        delegate?.didTappedSubmitBtn()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {
    func addTopShadow(shadowColor : UIColor,
                      shadowOpacity : Float,
                      shadowRadius : CGFloat,
                      offset:CGSize){
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
        self.clipsToBounds = false
    }
}
