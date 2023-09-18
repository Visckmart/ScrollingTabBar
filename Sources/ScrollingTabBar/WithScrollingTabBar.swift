//
//  File.swift
//  
//
//  Created by Victor Martins on 30/08/23.
//

import SwiftUI

@available(iOS 16.4, *)
struct ScrollingTabBarModifier<T: Tab, SheetContent: View>: ViewModifier {
    
    var isPresented: Binding<Bool> = .constant(true)
    var tabs: [T]
    var selectedTab: Binding<TabSelection>
    var leftFixedTab: FixedTab?
    var rightFixedTab: FixedTab?
    var presentationDetent: Binding<PresentationDetent> = .constant(.height(75))
    
    var sheetContent: SheetContent
    
    var tint: (color: Color, intensity: Double) = (.clear, 0)
    
    init(
        isPresented: Binding<Bool> = .constant(true),
        tint: (color: Color, intensity: Double)? = nil,
        tabs: [T],
        selectedTab: Binding<TabSelection>,
        leftFixedTab: FixedTab? = nil,
        rightFixedTab: FixedTab? = nil,
        presentationDetent: Binding<PresentationDetent> = .constant(.height(75)),
        sheetContent: () -> SheetContent
    ) {
        self.isPresented = isPresented
        self.tint = tint ?? (.clear, 0)
        self.tabs = tabs
        self.selectedTab = selectedTab
        self.leftFixedTab = leftFixedTab
        self.rightFixedTab = rightFixedTab
        self.presentationDetent = presentationDetent
        self.sheetContent = sheetContent()
    }
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: isPresented) {
                GeometryReader { proxy in
                    VStack(spacing: 0) {
                        ZStack(alignment: .top) {
                            ScrollingTabBar(
                                tabs: tabs,
                                selectedTab: selectedTab,
                                leftFixedTab: leftFixedTab,
                                rightFixedTab: rightFixedTab
                            )
                            .animation(nil, value: proxy.size.height)
                            .opacity(proxy.size.height == 75 ? 1 : 0)
                            .animation(.default.speed(1.5), value: proxy.size.height)
                            
                            sheetContent
                                .animation(nil, value: proxy.size.height)
                                .opacity(proxy.size.height != 75 ? 1 : 0)
                                .animation(.default.speed(1.5), value: proxy.size.height)
                        }
                        Spacer(minLength: 0)
                    }
                    .presentationDragIndicator(.hidden)
                    .frame(maxHeight: .infinity)
                    .padding(.top, 16)
                    .presentationDetents([.height(75), .large], selection: presentationDetent)
                    .presentationBackgroundInteraction(.enabled(upThrough: .height(75)))
                    .presentationCornerRadius(24)
                    .presentationContentInteraction(.automatic)
                    .interactiveDismissDisabled()
                    .presentationBackground {
//                        ZStack(alignment: .top) {
//                            AdjustableVisualEffectView(
//                                effect: UIBlurEffect(style: .dark),
//                                effectIntensity: 0.55 + ((proxy.size.height - 75)/350) * 0.3,
//                                color: tint.0,
//                                colorIntensity: tint.1
//                            )
//                            .frame(height: 1000)
//                            .overlay {
                                VStack {
//                                    
                                    RoundedRectangle(cornerRadius: 24)
//                                        .fill(.red)
                                        .stroke(.white.opacity(0.3), lineWidth: 0.5)
                                        .padding(.vertical, 0.25)
                                        .padding(.horizontal, 0.25)
                                        .frame(maxHeight: .infinity, alignment: .top)
                                        .mask {
//                                            Rectangle().fill(.black)
                                            LinearGradient(stops: [Gradient.Stop(color: .black, location: 0), Gradient.Stop(color: .clear, location: 1)], startPoint: .top, endPoint: .bottom)
                                            .frame(height: 24)
                                            .frame(maxHeight: .infinity, alignment: .top)}
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(
                                    AdjustableVisualEffectView(
                                        effect: UIBlurEffect(style: .dark),
                                        effectIntensity: 0.55 + ((proxy.size.height - 75)/350) * 0.3,
                                        color: tint.0,
                                        colorIntensity: tint.1
                                    )
                                    .frame(height: 1000)
                                )
//                            }
//                                .mask {
//                                    Rectangle()
//                                        .fill(.black)
//                                        .frame(height: 24)
//                                        .frame(maxHeight: .infinity, alignment: .top)
//                                }
//                        }
                    }
                }
            }
    }
}

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
