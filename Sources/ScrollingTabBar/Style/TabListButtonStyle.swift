//
//  TabListButtonStyle.swift
//  ScrollingTabBar
//
//  Created by Victor Martins on 19/08/23.
//

import SwiftUI

struct TabListButtonStyle: ButtonStyle {
    
    let color: Color
    var isSelected: Bool = false
    var minWidth: Double = 130
    
    func makeBody(configuration: Configuration) -> some View {
        let foregroundStyleOpacity = isSelected ? 1 : (configuration.isPressed ? 0.75 : 0.5)
        let backgroundOpacity = isSelected ? 0.7 : (configuration.isPressed ? 0.5 : 0.35)
        
        configuration.label
            .lineLimit(1)
            .contentShape(Rectangle())
            .foregroundStyle(.primary.opacity(foregroundStyleOpacity))
            .environment(\.colorScheme, .dark)
            .font(.headline.weight(.medium))
            .imageScale(.small)
            .padding(8)
            .frame(minHeight: 40)
            .frame(minWidth: minWidth)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .background(
                AdjustableVisualEffectView(
                    effect: UIBlurEffect(style: .systemUltraThinMaterialLight),
                    effectIntensity: 0.15,
                    color: color,
                    colorIntensity: backgroundOpacity
                ).contentShape(Rectangle())
            )
            .contentShape(Rectangle())
            .allowsHitTesting(true)
            .cornerRadius(8)
            .animation(.easeOut.speed(4), value: configuration.isPressed)
            .animation(.easeOut.speed(2.5), value: isSelected)
    }
}

#Preview {
    HStack {
        Button("Example tab", action: {})
            .buttonStyle(TabListButtonStyle(color: .blue, isSelected: false))
        
        Button("Example tab", action: {})
            .buttonStyle(TabListButtonStyle(color: .blue, isSelected: true))
    }
}
