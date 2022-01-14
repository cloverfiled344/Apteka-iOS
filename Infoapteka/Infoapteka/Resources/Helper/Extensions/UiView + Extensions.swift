//
//  UiView + Extensions.swift
//  Infoapteka
//
//  
//

import UIKit

extension UIView {

    func pulsate() {
        self.pulsate(sender: self)
    }

    func pulsate(sender: UIView) {
        let pulsate = CASpringAnimation(keyPath: "transform.scale")
        pulsate.duration = 0.5
        pulsate.repeatCount = 0
        pulsate.autoreverses = false
        pulsate.fromValue = 0.94
        pulsate.toValue = 0.99
        pulsate.autoreverses = false
        pulsate.initialVelocity = 0
        pulsate.damping = 1
        layer.add(pulsate, forKey: nil)
    }

    func setShadow(radius: CGFloat, color: UIColor) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.cornerRadius = radius
    }

    func roundedCorners(corners : UIRectCorner, radius : CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { addSubview($0) }
    }
}

extension UIView{
    func animationZoom(scaleX: CGFloat, y: CGFloat) {
        self.transform = CGAffineTransform(scaleX: scaleX, y: y)
    }

    func animationRoted(angle : CGFloat) {
        self.transform = CGAffineTransform(rotationAngle: 2 * .pi)
//        self.transform.rotated(by: angle)
    }
}
