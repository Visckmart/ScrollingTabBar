//
//  HorizontalTabsView.swift
//
//  Created by Victor Martins on 18/09/23.
//

import Foundation
import SwiftUI

internal struct HorizontalTabsView<T: Tab>: View {
    
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
                .background(SizeReaderView())
                .scrollIndicators(.hidden)
                .mask(leftGradient)
                .mask(rightGradient)
                .onChange(of: selectedTab) { newTabSelection in
                    withAnimation {
                        scrollProxy.scrollTo(newTabSelection.id, anchor: .center)
                    }
                }
            }
            .overlay(centeredTabDetector)
            .onPreferenceChange(ViewSizesPreferenceKey.self) { tabRects in
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
            .background(SizeReaderView())
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
            .background(SizeReaderView())
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
