//
//  TabSelection.swift
//  ScrollingTabBar
//
//  Created by Victor Martins on 19/08/23.
//

import Foundation

public enum TabSelection: Equatable {
    
    public typealias TabID = String
    
    case fixedLeft
    case fixedRight
    case tab(TabID)
    
    public var id: TabID? {
        switch self {
        case .tab(let id):
            return id
        default:
            return nil
        }
    }
}
