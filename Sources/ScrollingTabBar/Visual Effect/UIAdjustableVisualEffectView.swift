////
////  UIAdjustableVisualEffectView.swift
////
////  Created by Victor Martins on 30/08/23.
////

import UIKit

internal final class UIAdjustableVisualEffectView: UIVisualEffectView {
    
    var visualEffect: UIVisualEffect
    var effectIntensity: CGFloat {
        didSet { self.setNeedsDisplay() }
    }
    
    var color: UIColor {
        didSet { self.coloredBackground.backgroundColor = color }
    }
    var colorIntensity: Double {
        didSet { self.updateColorIntensity() }
    }
    var colorChangeTime: TimeInterval
    
    private let coloredBackground = UIView()
    private var animator: UIViewPropertyAnimator?
    
    init(
        effect visualEffect: UIVisualEffect,
        effectIntensity: CGFloat = 1,
        color: UIColor = .clear,
        colorIntensity: Double = 0,
        colorChangeTime: TimeInterval = 0.1
    ) {
        self.visualEffect = visualEffect
        self.effectIntensity = effectIntensity
        self.color = color
        self.colorIntensity = colorIntensity
        self.colorChangeTime = colorChangeTime
        
        super.init(effect: nil)
        
        self.coloredBackground.bounds = self.contentView.bounds
        self.coloredBackground.backgroundColor = color
        self.coloredBackground.alpha = colorIntensity
        self.contentView.addSubview(self.coloredBackground)
        
        self.coloredBackground.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.coloredBackground.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.coloredBackground.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.coloredBackground.topAnchor.constraint(equalTo: self.topAnchor),
            self.coloredBackground.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("\(#function) not implemented") }
    
    deinit {
        animator?.stopAnimation(true)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        effect = nil
        animator?.stopAnimation(true)
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [unowned self] in
            self.effect = visualEffect
        }
        animator?.fractionComplete = effectIntensity
    }
    
    private func updateColorIntensity() {
        let animationFadeOut = CABasicAnimation(keyPath: "opacity")
        let current = self.coloredBackground.alpha
        self.coloredBackground.alpha = self.colorIntensity
        animationFadeOut.fromValue = current
        animationFadeOut.toValue = NSNumber(value: self.colorIntensity)
        animationFadeOut.duration = self.colorChangeTime
        self.coloredBackground.layer.add(animationFadeOut, forKey: nil)
    }
}
