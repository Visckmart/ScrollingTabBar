//
//  ScrollingTabBar.swift
//  ScrollingTabBar
//
//  Created by Victor Martins on 19/08/23.
//

import SwiftUI
import Combine

/// A tab bar that has a scrolling behavior for when the tabs overflow, and
/// that is compatible with fixed tabs on the left and on the right side.
public struct ScrollingTabBar<T: Tab>: View {
    
    public let tabs: [T]
    
    public var leftFixedTab: FixedTab?
    public var rightFixedTab: FixedTab?
    
    @Binding public var selectedTab: TabSelection
    
    public init(
        tabs: [T],
        selectedTab: Binding<TabSelection>,
        leftFixedTab: FixedTab? = nil,
        rightFixedTab: FixedTab? = nil
    ) {
        self.tabs = tabs
        self.leftFixedTab = leftFixedTab
        self.rightFixedTab = rightFixedTab
        self._selectedTab = selectedTab
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            leftFixedButton
            
            HorizontalTabsView(
                tabs: tabs,
                selectTab: selectTab(_:),
                selectedTab: $selectedTab
            )
            
            rightFixedButton
        }
        .shadow(color: Color(white: 0.15).opacity(0.3), radius: 4, x: 0, y: 2)
        .padding(.leading, leftFixedTab == nil ? 6 : 16)
        .padding(.trailing, rightFixedTab == nil ? 6 : 16)
        .allowsHitTesting(true)
    }
    
    
    // MARK: Fixed Buttons
    
    @ViewBuilder
    private var leftFixedButton: some View {
        if let leftFixedTab {
            Button {
                self.selectTab(.fixedLeft)
            } label: {
                Image(systemName: leftFixedTab.iconName)
            }
            .buttonStyle(
                TabCompactButtonStyle(
                    color: leftFixedTab.color,
                    isSelected: selectedTab == .fixedLeft
                )
            )
        }
    }
    
    @ViewBuilder
    private var rightFixedButton: some View {
        if let rightFixedTab {
            Button {
                self.selectTab(.fixedRight)
            } label: {
                Image(systemName: rightFixedTab.iconName)
            }
            .buttonStyle(
                TabCompactButtonStyle(
                    color: rightFixedTab.color,
                    isSelected: selectedTab == .fixedRight
                )
            )
        }
    }
    
    private func selectTab(_ tab: TabSelection) {
        
        if self.selectedTab != tab {
            UIImpactFeedbackGenerator(style: tab == .fixedLeft ? .rigid : .soft)
            .impactOccurred(intensity: 0.75)
            self.selectedTab = tab
        }
    }
}



// #Preview("Scrolling") {
//    CompactTabListView(places: currentPlaces)
// }

// #Preview("Non-scrolling") {
//    CompactTabListView(places: Array(currentPlaces.prefix(2)))
// }
