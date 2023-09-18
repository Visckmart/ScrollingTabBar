//
//  ScrollingTabBar.swift
//  ScrollingTabBar
//
//  Created by Victor Martins on 19/08/23.
//

import SwiftUI
import Combine

public struct ScrollingTabBar<T: NamedTab>: View {
    
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

private struct HorizontalTabsView<T: NamedTab>: View {
    
    let tabs: [T]
    let selectTab: (TabSelection) -> Void

    @Binding var selectedTab: TabSelection
    
    @State private var centeredTab: TabSelection?
    @State var widthEstimate: Double = 130
    
    var body: some View {
        if tabs.isEmpty {
            Spacer()
        } else if tabs.count <= 2 {
            HStack(spacing: 10) {
                listContent(biggest: widthEstimate)
            }
            .padding(.horizontal, 10)
        } else {
            ScrollViewReader { scrollProxy in
                ScrollView(.horizontal) {
                    HStack(spacing: 10) {
                        listContent(scrollProxy: scrollProxy, biggest: widthEstimate)
                    }
                    .padding(.horizontal, 10)
                    .background(scrollStopMonitor(scrollProxy: scrollProxy))
                }
                .background(SizeReader())
                .scrollIndicators(.hidden)
                .mask(leftGradient)
                .mask(rightGradient)
            }
            .overlay(centeredTabDetector)
            .onPreferenceChange(ViewSizes.self) { tabRects in
                self.widthEstimate = tabRects.max(by: {$0.width < $1.width})!.width
                self.checkCenteredTab(tabRects: tabRects)
            }
        }
    }
    
    private func listContent(scrollProxy: ScrollViewProxy? = nil, biggest: Double) -> some View {
        ForEach(tabs) { tab in
            Button {
                self.selectTab(.tab(tab.id))
                withAnimation {
                    scrollProxy?.scrollTo(tab.id, anchor: .center)
                }
            } label: {
                Label(tab.name, systemImage: tab.iconName)
            }
            .buttonStyle(
                TabListButtonStyle(
                    color: tab.color,
                    isSelected: tab.id == selectedTab.id,
                    minWidth: biggest/2
                )
            )
            .background(SizeReader())
            .id(tab.id)
        }
        .animation(.easeOut.speed(4), value: selectedTab)
    }
    
    // MARK: Tab positioning
    
    private var centeredTabDetector: some View {
        Rectangle()
            .fill(.clear)
            .frame(width: 1, height: 1)
            .allowsHitTesting(false)
            .background(SizeReader())
    }
    
    private func checkCenteredTab(tabRects: [CGRect]) {
        guard let lastTabRect = tabRects.last else { return }
        let horizontallySortedTabFrames = tabRects.dropLast(1).sorted {
            $0.origin.x < $1.origin.x
        }
        
        for (index, tabRect) in horizontallySortedTabFrames.enumerated() {
            let intersection = tabRect.intersection(lastTabRect)
            if intersection.size != .zero {
                centeredTab = .tab(tabs[index].id)
                break
            }
        }
    }
    
    private func scrollStopMonitor(scrollProxy: ScrollViewProxy) -> some View {
        ScrollViewOffsetReader()
            .onScrollingFinished {
                withAnimation {
                    if let centeredTab {
                        self.selectTab(centeredTab)
                    }
                    scrollProxy.scrollTo(centeredTab?.id, anchor: .center)
                }
            }
            .frame(height: 0)
    }
    
    // MARK: Fade gradients
    
    private var leftGradient: some View {
        LinearGradient(stops: [
            Gradient.Stop(color: .clear, location: 0),
            Gradient.Stop(color: .black, location: 0.045)
        ], startPoint: .leading, endPoint: .trailing)
        .allowsHitTesting(false)
    }
    
    private var rightGradient: some View {
        LinearGradient(stops: [
            Gradient.Stop(color: .black, location: 0.955),
            Gradient.Stop(color: .clear, location: 1)
        ], startPoint: .leading, endPoint: .trailing)
        .allowsHitTesting(false)
    }
    
}

// #Preview("Scrolling") {
//    CompactTabListView(places: currentPlaces)
// }

// #Preview("Non-scrolling") {
//    CompactTabListView(places: Array(currentPlaces.prefix(2)))
// }
