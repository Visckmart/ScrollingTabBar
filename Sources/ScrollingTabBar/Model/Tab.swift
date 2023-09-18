//
//  Tab.swift
//  ScrollingTabBar
//
//  Created by Victor Martins on 30/08/23.
//

import Foundation
import struct SwiftUI.Color

public protocol Tab: Identifiable {
    var id: String { get set }
    var iconName: String { get set }
    var color: Color { get set }
}

public protocol NamedTab: Tab {
    var name: String { get set }
}

public struct FixedTab: NamedTab {
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
