//
//  Extensions.swift
//  DBEdit
//
//  Created by Vito Sartori on 15/11/25.
//

import SwiftUI

extension NSColor {
    func readableTextColor() -> NSColor {
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

extension Set {
    subscript(contains element: Element) -> Bool {
        get {
            contains(element)
        }
        set {
            if newValue {
                self.insert(element)
            } else {
                self.remove(element)
            }
        }
    }
}

extension CGRect {
    subscript(_ point: UnitPoint) -> CGPoint {
        get {
            return .init(x: minX + point.x * width, y: minY + point.y * height)
        }

        set {
            var oldValue = self

            switch point.x {
            case 1:
                size.width += newValue.x - maxX
            case 0:
                let newWidth = maxX - newValue.x
                origin.x = newValue.x
                size.width = newWidth
            default:
                ()
            }

            if size.width < 50 {
                self = oldValue
            }

            oldValue = self
            switch point.y {
            case 1:
                size.height += maxY - newValue.y
            case 0:
                let newHeight = maxY - newValue.y
                origin.y = newValue.y
                size.height = newHeight
            default:
                ()
            }
            if size.height < 50 {
                self = oldValue
            }
        }
    }
}

struct ColumnGeometryKey: PreferenceKey {
    static var defaultValue: [Column.ID: CGRect] = [:]

    static func reduce(value: inout [Column.ID: CGRect],
                       nextValue: () -> [Column.ID: CGRect]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

extension View {
    func reportColumnFrame(id: Column.ID,
                           in space: CoordinateSpace = .named("graph")) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear.preference(
                    key: ColumnGeometryKey.self,
                    value: [id: proxy.frame(in: space)]
                )
            }
        )
    }
}


extension View {
    func toolWindow<Content: View>(
        isPresented: Binding<Bool>,
        title: String,
        size: CGSize = .init(width: 350, height: 450),
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        background(
            ToolWindowPresenter(
                isPresented: isPresented,
                title: title,
                size: size,
                content: content
            )
        )
    }
}
