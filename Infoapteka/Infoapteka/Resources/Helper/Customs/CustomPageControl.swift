//
//  CustomPageControl.swift
//  Infoapteka
//
//

import UIKit

public class CustomPageControl: UIControl {

    @IBInspectable
    public var isEndless: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable
    public var numberOfPages: Int = 0 {
        didSet {
            drawSurface(bounds)
        }
    }

    @IBInspectable
    public var currentPage: Int = 0 {
        willSet {
            if isEndless {
                if currentPage < newValue {
                    goForward()
                } else if newValue < currentPage {
                    goBackward()
                }
            }
        }
        didSet {
            if !isEndless {
                guard dotLayers.count > 0 else {
                    return
                }
                redrawDotsWithAnimation()
            }
        }
    }

    @IBInspectable
    public var surfaceColor: UIColor = .lightGray
    @IBInspectable
    public var activeColor: UIColor = .black

    @IBInspectable
    public var strokeColor: UIColor = .red

    @IBInspectable
    public var lineWidth: CGFloat = 1

    private var spacing: CGFloat = 5
    private var surfacePageSize: CGSize = .zero
    private var activePageSize: CGSize = .zero

    private var isAnimating: Bool = false

    let endlessLayer1 = CAShapeLayer()
    let endlessLayer2 = CAShapeLayer()
    let endlessLayer3 = CAShapeLayer()

    let stepOneDuration = 0.1
    let stepTwoDuration = 0.2

    public override func awakeFromNib() {
        super.awakeFromNib()

        if isEndless {
            layer.addSublayer(endlessLayer1)
            layer.addSublayer(endlessLayer2)
            layer.addSublayer(endlessLayer3)
            drawEndless(bounds)
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        if isEndless {
            drawEndless(bounds)
        } else {
            redrawDots()
        }
    }

    private var dotLayers = [CAShapeLayer]()
    private var viewWidth: CGFloat {
        return bounds.width
    }

    private var viewMidX: CGFloat {
        return bounds.midX
    }

    private var viewMidY: CGFloat {
        return bounds.midY
    }

    private var totalPagesWidth: CGFloat {
        if numberOfPages == 1 {
            return activePageSize.width
        } else {
            let inactivePagesWidth = CGFloat(numberOfPages - 1) * surfacePageSize.width
            let activePageWidth = activePageSize.width
            let totalSpacing = CGFloat(numberOfPages - 1) * spacing
            return inactivePagesWidth + activePageWidth + totalSpacing
        }
    }

    private let animationDuration: TimeInterval = 0.3

}

// MARK: - Default
extension CustomPageControl {
    private func drawSurface(_ rect: CGRect) {
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        surfacePageSize = CGSize(width: rect.height, height: rect.height)
        activePageSize = CGSize(width: rect.height * 3, height: rect.height)

        generateSurfaceShapes()
        dotLayers.forEach { dotLayer in
            layer.addSublayer(dotLayer)
        }
        redrawDots()
    }

    private func generateSurfaceShapes() {
        if !dotLayers.isEmpty {
            dotLayers.removeAll()
        }
        for n in 0..<numberOfPages {
            let dotLayer = CAShapeLayer()
            dotLayer.lineWidth = lineWidth
            dotLayer.fillColor = surfaceColor.cgColor
            dotLayer.strokeColor = strokeColor.cgColor
            dotLayers.insert(dotLayer, at: n)
        }
    }

    private func getPageStartXPostition(for index: Int) -> CGFloat {
        let startXPosition = viewMidX - totalPagesWidth / 2
        let totalSpacing = CGFloat(index) * spacing
        let totalPreviousPagesWidth = CGFloat(index) * surfacePageSize.width
        return totalPreviousPagesWidth + totalSpacing + startXPosition
    }

    private func pathForDotLayer(index: Int) -> UIBezierPath {
        let minX = getPageStartXPostition(for: index)
        let newRect = CGRect(x: index <= currentPage ? minX : minX + activePageSize.width - surfacePageSize.width,
                             y: 0,
                             width: index == currentPage ? activePageSize.width : surfacePageSize.width,
                             height: index == currentPage ? activePageSize.height : surfacePageSize.height)
        let newPath = UIBezierPath(roundedRect: newRect,
                                   cornerRadius: index == currentPage ? activePageSize.height : surfacePageSize.height)
        return newPath
    }

    private func animationForPath(_ path: CGPath, duration: TimeInterval) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = duration
        animation.toValue = path
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false

        return animation
    }

    private func redrawDots() {
        for (index, dotLayer) in dotLayers.enumerated() {
            let newPath = pathForDotLayer(index: index).cgPath
            dotLayer.path = newPath
            dotLayer.fillColor = index == currentPage ? activeColor.cgColor : surfaceColor.cgColor
        }
    }

    private func redrawDotsWithAnimation() {
        for (hint, dotLayer) in dotLayers.enumerated() {
            let newPath = pathForDotLayer(index: hint).cgPath
            let animation = animationForPath(newPath, duration: animationDuration)
            dotLayer.add(animation, forKey: nil)
            dotLayer.fillColor = hint == currentPage ? activeColor.cgColor : surfaceColor.cgColor
        }
    }
}

// MARK: - Endless
extension CustomPageControl {
    private func drawEndless(_ rect: CGRect) {
        activePageSize = .init(width: rect.height * 3, height: rect.height)
        surfacePageSize = .init(width: rect.height, height: rect.height)

        endlessLayer1.anchorPoint = .init(x: 0, y: 0)
        endlessLayer1.frame = CGRect(x: 0, y: 0, width: activePageSize.width + spacing + surfacePageSize.width, height: surfacePageSize.height)
        endlessLayer1.fillColor = activeColor.cgColor
        endlessLayer1.path = UIBezierPath(roundedRect: CGRect(x: 0,
                                                              y: 0,
                                                              width: activePageSize.width,
                                                              height: activePageSize.height),
                                          cornerRadius: activePageSize.height * 0.5).cgPath
        endlessLayer1.position = CGPoint(x: viewMidX - endlessLayer1.frame.width * 0.5, y: 0)

        endlessLayer2.anchorPoint = .init(x: 0, y: 0)
        endlessLayer2.frame = CGRect(x: 0, y: 0, width: activePageSize.width + spacing + surfacePageSize.width, height: surfacePageSize.height)
        endlessLayer2.fillColor = activeColor.cgColor
        endlessLayer2.path = UIBezierPath(roundedRect: CGRect(x: activePageSize.width + spacing,
                                                              y: 0,
                                                              width: surfacePageSize.width,
                                                              height: surfacePageSize.height),
                                          cornerRadius: surfacePageSize.height * 0.5).cgPath
        endlessLayer2.position = CGPoint(x: viewMidX - endlessLayer2.frame.width * 0.5, y: 0)

        endlessLayer3.anchorPoint = .init(x: 0, y: 0)
        endlessLayer3.frame = CGRect(x: 0, y: 0, width: activePageSize.width + spacing + surfacePageSize.width, height: surfacePageSize.height)
        endlessLayer3.fillColor = activeColor.cgColor
        endlessLayer3.path = UIBezierPath(roundedRect: CGRect(x: 0,
                                                              y: 0,
                                                              width: surfacePageSize.width,
                                                              height: surfacePageSize.height),
                                          cornerRadius: surfacePageSize.height * 0.5).cgPath
        endlessLayer3.position = CGPoint(x: viewMidX - endlessLayer3.frame.width * 0.5, y: 0)
    }

    private func goForward() {
        guard !isAnimating else {
            return
        }
        isAnimating = true
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.endlessLayer1.removeAllAnimations()
            self.endlessLayer2.removeAllAnimations()
            self.endlessLayer3.removeAllAnimations()
            self.isAnimating = false
        }
        let move = moveAnimation(from: endlessLayer1.position,
                                 to: CGPoint(x: endlessLayer1.position.x + surfacePageSize.width + spacing,
                                             y: endlessLayer1.position.y))

        let fadeIn = CABasicAnimation(keyPath: "opacity")
        fadeIn.duration = stepOneDuration
        fadeIn.fromValue = 0
        fadeIn.toValue = 1
        fadeIn.timingFunction = CAMediaTimingFunction(name: .default)
        fadeIn.isRemovedOnCompletion = false
        fadeIn.fillMode = .forwards

        let fadeOut = CABasicAnimation(keyPath: "opacity")
        fadeOut.duration = stepOneDuration
        fadeOut.fromValue = 1
        fadeOut.toValue = 0
        fadeOut.timingFunction = CAMediaTimingFunction(name: .default)
        fadeOut.isRemovedOnCompletion = false
        fadeOut.fillMode = .forwards

        let increase = CABasicAnimation(keyPath: "path")
        increase.duration = stepTwoDuration
        increase.toValue = UIBezierPath(roundedRect: CGRect(x: 0,
                                                            y: 0,
                                                            width: activePageSize.width,
                                                            height: activePageSize.height),
                                        cornerRadius: activePageSize.height * 0.5).cgPath
        increase.timingFunction = CAMediaTimingFunction(name: .default)
        increase.beginTime = CACurrentMediaTime() + stepOneDuration
        increase.isRemovedOnCompletion = false
        increase.fillMode = .forwards

        let decrease = CABasicAnimation(keyPath: "path")
        decrease.duration = stepTwoDuration
        decrease.toValue = UIBezierPath(roundedRect: CGRect(x: surfacePageSize.width * 2,
                                                            y: 0,
                                                            width: surfacePageSize.width,
                                                            height: surfacePageSize.height),
                                        cornerRadius: surfacePageSize.height * 0.5).cgPath
        decrease.timingFunction = CAMediaTimingFunction(name: .default)
        decrease.beginTime = CACurrentMediaTime() + stepOneDuration
        decrease.isRemovedOnCompletion = false
        decrease.fillMode = .forwards


        endlessLayer1.add(move, forKey: "move")
        endlessLayer2.add(fadeOut, forKey: "fadeOut")
        endlessLayer3.add(fadeIn, forKey: "fadeIn")
        endlessLayer1.add(decrease, forKey: "decreaseThree")
        endlessLayer3.add(increase, forKey: "increaseThree")

        CATransaction.commit()
    }

    private func moveAnimation(from: CGPoint, to: CGPoint) -> CABasicAnimation {
        let move = CABasicAnimation(keyPath: "position")
        move.duration = stepOneDuration
        move.fromValue = [from.x, from.y]
        move.toValue = [to.x, to.y]
        move.timingFunction = CAMediaTimingFunction(name: .default)
        move.isRemovedOnCompletion = false
        move.fillMode = .forwards
        return move
    }

    private func increaseAnimation(to: UIBezierPath) -> CABasicAnimation {
        let increase = CABasicAnimation(keyPath: "path")
        increase.duration = stepOneDuration
        increase.toValue = to.cgPath
        increase.timingFunction = CAMediaTimingFunction(name: .default)
        increase.isRemovedOnCompletion = false
        increase.fillMode = .forwards
        return increase
    }

    private func goBackward() {
        guard !isAnimating else {
            return
        }
        isAnimating = true
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.endlessLayer1.removeAllAnimations()
            self.endlessLayer2.removeAllAnimations()
            self.endlessLayer3.removeAllAnimations()


            CATransaction.begin()
            CATransaction.setDisableActions(true)
            self.endlessLayer3.position = CGPoint(x: self.viewMidX - (self.endlessLayer3.frame.width * 0.5), y: 0)
            CATransaction.commit()

            self.isAnimating = false
        }
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        endlessLayer3.position = CGPoint(x: self.viewMidX - (self.endlessLayer3.frame.width * 0.5) + activePageSize.width + spacing, y: 0)
        CATransaction.commit()


        let decrease = CABasicAnimation(keyPath: "path")
        decrease.duration = stepOneDuration
        decrease.toValue = UIBezierPath(roundedRect: CGRect(x: 0,
                                                            y: 0,
                                                            width: surfacePageSize.width,
                                                            height: surfacePageSize.height),
                                        cornerRadius: surfacePageSize.height * 0.5).cgPath
        decrease.timingFunction = CAMediaTimingFunction(name: .default)
        decrease.isRemovedOnCompletion = false
        decrease.fillMode = .forwards


        let from = UIBezierPath(cgPath: endlessLayer2.path ?? CGPath(rect: .init(), transform: nil)).bounds.minX
        let increaseTo = UIBezierPath(roundedRect: CGRect(x: from - (activePageSize.width - surfacePageSize.width),
                                                          y: 0,
                                                          width: activePageSize.width,
                                                          height: activePageSize.height),
                                      cornerRadius: activePageSize.height * 0.5)
        let increase = increaseAnimation(to: increaseTo)

        let move = CABasicAnimation(keyPath: "position")
        move.beginTime = CACurrentMediaTime() + stepOneDuration
        move.duration = stepTwoDuration
        move.toValue = [endlessLayer2.position.x - surfacePageSize.width - spacing, endlessLayer2.position.y]
        move.timingFunction = CAMediaTimingFunction(name: .default)
        move.isRemovedOnCompletion = false
        move.fillMode = .forwards


        let fadeOut = CABasicAnimation(keyPath: "opacity")
        fadeOut.beginTime = CACurrentMediaTime() + stepOneDuration
        fadeOut.duration = stepTwoDuration
        fadeOut.fromValue = 1
        fadeOut.toValue = 0
        fadeOut.timingFunction = CAMediaTimingFunction(name: .default)
        fadeOut.isRemovedOnCompletion = false
        fadeOut.fillMode = .forwards

        let fadeIn = CABasicAnimation(keyPath: "opacity")
        fadeIn.beginTime = CACurrentMediaTime() + stepOneDuration
        fadeIn.duration = stepTwoDuration
        fadeIn.fromValue = 0
        fadeIn.toValue = 1
        fadeIn.timingFunction = CAMediaTimingFunction(name: .default)
        fadeIn.isRemovedOnCompletion = false
        fadeIn.fillMode = .forwards

        endlessLayer1.add(decrease, forKey: "decrease1")
        endlessLayer2.add(increase, forKey: "increase1")
        endlessLayer2.add(move, forKey: "move1")
        endlessLayer1.add(fadeOut, forKey: "fadeOut1")
        endlessLayer3.add(fadeIn, forKey: "fadeIn1")
        CATransaction.commit()
    }
}
