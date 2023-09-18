//
//  TabCompactButtonStyle.swift
//  ScrollingTabBar
//
//  Created by Victor Martins on 19/08/23.
//

import SwiftUI

struct TabCompactButtonStyle: ButtonStyle {
    
    let color: Color
    var isSelected: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        let backgroundOpacity = isSelected ? 1 : (configuration.isPressed ? 0.75 : 0.35)
        
        configuration.label
            .fontWeight(.bold)
            .foregroundColor(.white)
            .labelStyle(.iconOnly)
            .padding(8)
            .frame(minWidth: 40, minHeight: 40)
            .background(
                AdjustableVisualEffectView(
                    effect: UIBlurEffect(style: .systemUltraThinMaterialDark),
                    effectIntensity: 0.15,
                    color: color,
                    colorIntensity: backgroundOpacity
                )
            )
            .cornerRadius(8)
            .animation(.easeOut.speed(4), value: configuration.isPressed)
            .animation(.easeOut.speed(2.5), value: isSelected)
    }
}
