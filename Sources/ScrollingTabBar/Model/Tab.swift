//
//  Tab.swift
//  ScrollingTabBar
//
//  Created by Victor Martins on 30/08/23.
//

import Foundation
import struct SwiftUI.Color

/// The `Tab` protocol defines what properties are needed to declare your own
/// type that acts as a tab.
///
/// If you are building a web browser, for example, you could declare a PageTab
/// as follows:
///
///     class PageTab: Tab {
///         var id: String
///         var iconName: String
///         var color: Color
///         var name: String
///
///         var history: [URL]
///     }
public protocol Tab: Identifiable {
    
    /// An tab identifier that's unique across all tabs of the same bar
    var id: String { get set }
    
    /// The name of the SF Symbol to show leading the tab's name
    var iconName: String { get set }
    
    /// The color to use as a tint for the background of the tab
    var color: Color { get set }
    
    /// The tab's name, which will be shown on the tab and set as the
    /// accessibility label
    var name: String { get set }
    
}

/// A tab that stays fixed on the leading or trailing area.
public struct FixedTab: Tab {
    public var id: String = UUID().uuidString
    public var name: String
    public var iconName: String
    public var color: Color
    
    public init(name: String, iconName: String, color: Color) {
        self.name = name
        self.iconName = iconName
        self.color = color
    }
}
