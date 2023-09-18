//
//  AdjustableVisualEffectView.swift
//
//  Created by Victor Martins on 30/08/23.
//

import SwiftUI

internal struct AdjustableVisualEffectView: UIViewRepresentable {
    
    let effect: UIVisualEffect
    let effectIntensity: CGFloat
    let color: Color
    let colorIntensity: Double
    let colorChangeTime: TimeInterval
    
    init(
        effect: UIVisualEffect,
        effectIntensity: CGFloat = 1,
        color: Color = .clear,
        colorIntensity: Double = 0,
        colorChangeTime: TimeInterval = 0.1
    ) {
        self.effect = effect
        self.effectIntensity = effectIntensity
        self.color = color
        self.colorIntensity = colorIntensity
        self.colorChangeTime = colorChangeTime
    }
    
    func makeUIView(context: Context) -> UIAdjustableVisualEffectView {
        UIAdjustableVisualEffectView(
            effect: effect,
            effectIntensity: effectIntensity,
            color: UIColor(color),
            colorIntensity: colorIntensity,
            colorChangeTime: colorChangeTime
        )
    }
    
    func updateUIView(_ uiView: UIAdjustableVisualEffectView, context: Context) {
        uiView.visualEffect = effect
        uiView.effectIntensity = effectIntensity
        uiView.color = UIColor(color)
        uiView.colorIntensity = colorIntensity
        uiView.colorChangeTime = colorChangeTime
    }
}
