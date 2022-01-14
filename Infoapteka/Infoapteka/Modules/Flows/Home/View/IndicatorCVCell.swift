//
//  IndicatorCVCell.swift
//  Infoapteka
//
//

import UIKit

class IndicatorCell: UICollectionViewCell {

    lazy private var inidicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .large
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(inidicator)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentView.addSubview(inidicator)
    }

    func setup(){
        inidicator.snp.remakeConstraints { make in
            make.height.width.equalTo(24.0)
            make.center.equalToSuperview()
        }
        inidicator.startAnimating()
    }

}
