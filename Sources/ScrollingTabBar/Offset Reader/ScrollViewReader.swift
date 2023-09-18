//
//  OffsetPreferenceKeys.swift
//
//  Created by Victor Martins on 20/08/23.
//
//  Built on top of: https://stackoverflow.com/a/73612181
//

import SwiftUI
import Combine

struct ScrollViewOffsetReader: View {
    
    private let onScrollingStarted: () -> Void
    private let onScrollingFinished: () -> Void
    
    private let scrollOffsetMonitor: CurrentValueSubject<CGFloat, Never>
    private let isScrollingMonitor: AnyPublisher<CGFloat, Never>
    
    @State private var scrolling: Bool = false
    
    init() {
        self.init(onScrollingStarted: {}, onScrollingFinished: {})
    }
    
    private init(
        onScrollingStarted: @escaping () -> Void,
        onScrollingFinished: @escaping () -> Void
    ) {
        self.onScrollingStarted = onScrollingStarted
        self.onScrollingFinished = onScrollingFinished
        
        self.scrollOffsetMonitor = CurrentValueSubject<CGFloat, Never>(0)
        self.isScrollingMonitor = scrollOffsetMonitor
            .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    var body: some View {
        GeometryReader { geoProxy in
            Rectangle()
                .frame(width: 0, height: 0)
                .onChange(of: geoProxy.frame(in: .global).origin.x) { offset in
                    if self.scrolling == false {
                        self.scrolling = true
                        self.onScrollingStarted()
                    }
                    self.scrollOffsetMonitor.send(offset)
                }
                .onReceive(self.isScrollingMonitor) { _ in
                    if self.scrolling {
                        self.scrolling = false
                        self.onScrollingFinished()
                    }
                }
        }
    }
    
    func onScrollingStarted(_ closure: @escaping () -> Void) -> Self {
        .init(
            onScrollingStarted: closure,
            onScrollingFinished: self.onScrollingFinished
        )
    }
    
    func onScrollingFinished(_ closure: @escaping () -> Void) -> Self {
        .init(
            onScrollingStarted: self.onScrollingStarted,
            onScrollingFinished: closure
        )
    }
}
