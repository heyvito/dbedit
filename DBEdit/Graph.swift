//
//  Graph.swift
//  DBEdit
//
//  Created by Vito Sartori on 14/11/25.
//

import Foundation
import SwiftUI

struct ResolvedEdge {
    let from: CGPoint
    let to: CGPoint
    let fromAttachment: UnitPoint
    let toAttachment: UnitPoint
}

struct Edge: Identifiable {
    var id: UUID = UUID()
    var source: Column.ID
    var destination: Column.ID
}
