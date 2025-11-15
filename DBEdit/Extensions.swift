//
//  Extensions.swift
//  DBEdit
//
//  Created by Vito Sartori on 15/11/25.
//

import SwiftUI

extension NSColor {
    /// Returns either .black or .white depending on which has better contrast
    func readableTextColor() -> NSColor {
        // Convert to sRGB to ensure consistent components
        guard let rgb = self.usingColorSpace(.sRGB) else {
            return .black
        }

        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        rgb.getRed(&r, green: &g, blue: &b, alpha: &a)

        func linearize(_ x: CGFloat) -> CGFloat {
            x <= 0.03928 ? x / 12.92 : pow((x + 0.055) / 1.055, 2.4)
        }

        let luminance =
            0.2126 * linearize(r) +
            0.7152 * linearize(g) +
            0.0722 * linearize(b)

        return luminance > 0.179 ? .black : .white
    }
}

extension Color {
    func readableTextColor() -> Color {
        let ns = NSColor(self)
        return Color(ns.readableTextColor())
    }
}
