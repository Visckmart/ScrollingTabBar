//
//  File.swift
//  
//
//  Created by Victor Martins on 30/08/23.
//

import SwiftUI

@available(iOS 16.4, *)
extension View {
    public func withScrollingTabBar<T: Tab, SheetContent: View>(
        isPresented: Binding<Bool> = .constant(true),
        tint: (color: Color, intensity: Double)? = nil,
        tabs: [T],
        selectedTab: Binding<TabSelection>,
        leftFixedTab: FixedTab? = nil,
        rightFixedTab: FixedTab? = nil,
        presentationDetent: Binding<PresentationDetent> = .constant(.height(75)),
        sheetContent: () -> SheetContent = { EmptyView() }
    ) -> some View {
        modifier(
            ScrollingTabBarModifier(
                isPresented: isPresented,
                tint: tint,
                tabs: tabs,
                selectedTab: selectedTab,
                leftFixedTab: leftFixedTab,
                rightFixedTab: rightFixedTab,
                presentationDetent: presentationDetent,
                sheetContent: sheetContent
            )
        )
    }
}
