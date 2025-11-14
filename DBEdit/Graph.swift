//
//  Graph.swift
//  DBEdit
//
//  Created by Vito Sartori on 14/11/25.
//

import Foundation
import SwiftUI

struct Graph {
    var nodes: [Node]
    var edges: [Edge]

    func node(with id: Node.ID) -> Node {
        nodes.first { $0.id == id }!
    }

    func resolve(edge: Edge) -> ResolvedEdge {
        let s = node(with: edge.source)
        let d = node(with: edge.destination)
        let sPoint = s.frame[.trailing]
        let dPoint = d.frame[.leading]
        return ResolvedEdge(from: sPoint, to: dPoint)
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

struct ResolvedEdge {
    var from: CGPoint
    var to: CGPoint
}

struct Node: Identifiable {
    var id: UUID = UUID()
    var title: String
    var frame: CGRect

    // TODO: Anchor points
}

struct Edge: Identifiable {
    var id: UUID = UUID()
    var source: Node.ID
    var destination: Node.ID

    // TODO: Anchor points
}
