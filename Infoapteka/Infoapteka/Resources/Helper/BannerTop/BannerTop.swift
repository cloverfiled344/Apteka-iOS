//
//  BannerTop.swift
//  Infoapteka
//
//

import UIKit

class BannerTop {

    static let instance = BannerTop()
    var banner: Banner?

    static func showToast(message: String?, and bgColor: UIColor = UIColor.systemGreen) {
        guard let message = message else {
            return
        }

        instance.banner?.dismiss()
        instance.banner = Banner(title: nil, subtitle: message, image: nil, backgroundColor: bgColor, didTapBlock: nil)
        instance.banner?.dismissesOnSwipe = true
        instance.banner?.dismissesOnTap = true
        instance.banner?.show(duration: 3.0)
    }

    static func makeToastWithText(_ text: String) {
        self.showToast(message: text)
    }
}
