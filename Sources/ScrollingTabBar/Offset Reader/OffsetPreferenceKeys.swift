//
//  OffsetPreferenceKeys.swift
//
//  Created by Victor Martins on 20/08/23.
//
//  Inspired by sections of: https://stackoverflow.com/a/60412447
//

import SwiftUI

struct ViewSizes: PreferenceKey {
    typealias Value = [CGRect]
    static var defaultValue: [CGRect] = []
    
    static func reduce(value: inout [CGRect], nextValue: () -> [CGRect]) {
        value.append(contentsOf: nextValue())
    }
}

struct SizeReader: View {
    var body: some View {
        GeometryReader { proxy in
            Color.clear
                .preference(key: ViewSizes.self, value: [proxy.frame(in: .global)])
        }
    }
}
