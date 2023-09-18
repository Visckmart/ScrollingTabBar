//
//  TabSelection.swift
//  ScrollingTabBar
//
//  Created by Victor Martins on 19/08/23.
//

import Foundation

/// A type that represents which tab is selected currently.
public enum TabSelection: Equatable {
    
    /// A type alias for the type of tabs' IDs
    public typealias TabID = String
    
    
    /// Represents the case where the fixed left tab is selected
    case fixedLeft
    
    /// Represents the case where the fixed right tab is selected
    case fixedRight
    
    /// Represents the case where the a tab is selected and holds its ID
    case tab(TabID)
    
    
    /// The identifier of the selected tab, or nil if it's a fixed tab.
    ///
    /// To check if a fixed tab is selected, their respective cases,
    /// compare the selection with the `fixedLeft` and `fixedRight` cases.
    public var id: TabID? {
        switch self {
        case .tab(let id): return id
        default: return nil
        }
    }
}
