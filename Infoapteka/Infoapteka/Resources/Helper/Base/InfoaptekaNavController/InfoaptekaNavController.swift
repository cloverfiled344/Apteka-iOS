//
//  BaseNavBar.swift
//  Infoapteka
//
//  
//

import UIKit

extension InfoaptekaNavController {
    struct Appearance {
        let backgroundColor = Asset.mainWhite.color
    }
}

class InfoaptekaNavController: UINavigationController {

    private let appearance = Appearance()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = appearance.backgroundColor
    }
}
