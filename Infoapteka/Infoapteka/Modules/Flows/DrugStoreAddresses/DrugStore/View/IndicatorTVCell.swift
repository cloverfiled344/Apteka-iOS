//
//  IndicatorTVCell.swift
//  Infoapteka
//
//  
//

import Foundation
import UIKit

class IndicatorTVCell: UITableViewCell {

    lazy private var inidicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .large
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
