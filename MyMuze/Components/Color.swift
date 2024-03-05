//
//  Color.swift
//  MyMuze
//
//  Created by Pete Potipitak on 2/2/24.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0,
            opacity: alpha
        )
    }
}

extension Color {
    // Used to set global colors of the app
    static let myMuzeBlack = Color(hex: 0x1E1E1E)
    static let myMuzeAccent = Color(hex: 0x8364FF)
    static let myMuzeWhite = Color(hex: 0xFFFFFF)
}
