//
//  SchemaLayout.swift
//  DBEdit
//
//  Created by Vito Sartori on 15/11/25.
//

import SwiftUI
import Combine

final class SchemaLayout: ObservableObject {
    enum FocusedElement {
        case none
        case column(Column.ID)
        case table(Table.ID)
    }

    @Published var columnFrames: [Column.ID: CGRect] = [:]
    @Published var higlightedColumnID: Column.ID?
    @Published var focusedElement: FocusedElement = .none
    @Published var selectedElements: Set<Table.ID> = []
    @Published var modifierKeys: EventModifiers = []

    func resolveEdge(document: SchemaDocument, for edge: Edge) -> ResolvedEdge {
        let sourceTable = document.tableForColumn(id: edge.source)!
        let destinationTable = document.tableForColumn(id: edge.destination)!
        let sourceTableFrame = sourceTable.position
        let destinationTableFrame = destinationTable.position

        let sFrame = sourceTable.isCollapsed ? sourceTable.position : columnFrames[edge.source]!
        let dFrame = destinationTable.isCollapsed ? destinationTable.position : columnFrames[edge.destination]!

        let (sEdge, dEdge) = attachmentPoints(between: sourceTableFrame, and: destinationTableFrame)

        return ResolvedEdge(
            from: sFrame[sEdge],
            to: dFrame[dEdge],
            fromAttachment: sEdge,
            toAttachment: dEdge
        )
    }

    func attachmentPoints(between source: CGRect, and destination: CGRect) -> (UnitPoint, UnitPoint) {
        // 1. Clear left/right cases
        if source.maxX <= destination.minX {
            // source completely left of destination
            return (.trailing, .leading)
        }

        if destination.maxX <= source.minX {
            // source completely right of destination
            return (.leading, .trailing)
        }

        // 2. Horizontal overlap: use same side, chosen by which way dest leans
        let dx = destination.midX - source.midX

        if dx >= 0 {
            // destination is (on average) to the right -> both use trailing
            return (.trailing, .trailing)
        } else {
            // destination is (on average) to the left -> both use leading
            return (.leading, .leading)
        }
    }

    func columnIDAt(_ point: CGPoint) -> Column.ID? {
        columnFrames.first(where: { $0.value.contains(point) })?.key
    }

    func makeColumnHighlighted(id: Column.ID?) {
        DispatchQueue.main.async {
            self.higlightedColumnID = id
        }
    }
}
