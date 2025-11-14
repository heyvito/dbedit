//
//  Vector2.swift
//  DBEdit
//
//  Created by Vito Sartori on 14/11/25.
//

import Foundation

protocol Vector2 {
    var x: CGFloat { get set }
    var y: CGFloat { get set }
    init(x: CGFloat, y: CGFloat)
}

extension Vector2 {
    static func *(lhs: Self, rhs: some Vector2) -> Self {
        .init(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
    }

    static func *(lhs: Self, rhs: CGFloat) -> Self {
        .init(x: lhs.x * rhs, y: lhs.y * rhs)
    }

    static func +(lhs: Self, rhs: some Vector2) -> Self {
        .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func +(lhs: Self, rhs: CGFloat) -> Self {
        .init(x: lhs.x + rhs, y: lhs.y + rhs)
    }

    static func +=(lhs: inout Self, rhs: some Vector2) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }

    static func -(lhs: Self, rhs: some Vector2) -> Self {
        .init(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    static func -(lhs: Self, rhs: CGFloat) -> Self {
        .init(x: lhs.x - rhs, y: lhs.y - rhs)
    }

    static func /(lhs: Self, rhs: some Vector2) -> Self {
        .init(x: lhs.x / rhs.x, y: lhs.y / rhs.y)
    }

    static func /(lhs: Self, rhs: CGFloat) -> Self {
        .init(x: lhs.x / rhs, y: lhs.y / rhs)
    }
}

extension CGPoint: Vector2 {}
extension CGSize: Vector2 {
    var x: CGFloat {
        get { width }
        set { width = newValue }
    }
    var y: CGFloat {
        get { height }
        set { height = newValue}
    }

    init(x: CGFloat, y: CGFloat) {
        self = CGSize(width: x, height: y)
    }
}
