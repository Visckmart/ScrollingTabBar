//
//  OffsetPreferenceKeys.swift
//
//  Created by Victor Martins on 20/08/23.
//
//  Inspired by sections of: https://stackoverflow.com/a/60412447
//

import SwiftUI

internal struct ViewSizesPreferenceKey: PreferenceKey {
    typealias Value = [CGRect]
    static var defaultValue: [CGRect] = []
    
    static func reduce(value: inout [CGRect], nextValue: () -> [CGRect]) {
        value.append(contentsOf: nextValue())
    }
}

internal struct SizeReaderView: View {
    var body: some View {
        GeometryReader { proxy in
            Color.clear
                .preference(key: ViewSizesPreferenceKey.self, 
                            value: [proxy.frame(in: .global)])
        }
    }
}
