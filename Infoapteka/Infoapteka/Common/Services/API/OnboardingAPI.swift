//
//  OnboardingAPPI.swift
//  Infoapteka
//
//

import Foundation

final class OnboardingAPI {

    func fetchPages(_ completion: @escaping (([OBPage]) -> Void)) {
        completion([
            OBPage(title: L10n.icOb1, icon: Asset.icOb1, titleColor: Asset.secondaryGray2.color, backgroundColor: Asset.mainWhite.color),
            OBPage(title: L10n.icOb2, icon: Asset.icOb2, titleColor: Asset.mainWhite.color, backgroundColor: Asset.mainBlue.color),
            OBPage(title: L10n.icOb3, icon: Asset.icOb3, titleColor: Asset.mainWhite.color, backgroundColor: Asset.mainGreen.color),
        ])
    }
}
