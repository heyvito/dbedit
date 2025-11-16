//
//  GraphView.swift
//  DBEdit
//
//  Created by Vito Sartori on 15/11/25.
//

import SwiftUI

struct GraphView: View {
    @ObservedObject var document: SchemaDocument
    @ObservedObject var layout: SchemaLayout

    struct LinkDrag: Equatable {
        var fromColumnID: UUID
        var startPoint: CGPoint
        var currentPoint: CGPoint
    }

    @State private var linkDrag: LinkDrag? = nil
    @State private var offset: CGSize = .zero

    var body: some View {
        ScrollableContainer(
            onScroll: { dx, dy in
                offset.width  += dx
                offset.height += dy
            },
            content: {
                content
                    .offset(offset)
            }
        )
    }

    var content: some View {
        ZStack(alignment: .topLeading) {
            Color.clear
                .contentShape(.rect)
                .onTapGesture {
                    document.layout.focusedElement = .none
                    document.layout.selectedElements.removeAll()
                }
            
            ForEach(document.schema.allEdges()) { edge in
                EdgeView(edge: document.layout.resolveEdge(document: document, for: edge))
            }
            
            ForEach($document.schema.tables) { $table in
                TableGraphView(
                    table: $table,
                    layout: document.layout,
                    onClick: {
                        if document.layout.modifierKeys.contains(.shift) {
                            switch document.layout.focusedElement {
                            case .column(let columnID):
                                if let table = document.tableForColumn(id: columnID) {
                                    document.layout.selectedElements.insert(table.id)
                                }
                            case .table(let tableID):
                                document.layout.selectedElements.insert(tableID)
                            default: ()
                            }
                            
                            document.layout.focusedElement = .none
                            document.layout.selectedElements.insert(table.id)
                        } else {
                            document.layout.focusedElement = .table(table.id)
                            document.layout.selectedElements.removeAll()
                            document.layout.selectedElements.insert(table.id)
                        }
                    }, onClickColumn: { column in
                        document.layout.focusedElement = .column(column.id)
                        document.layout.selectedElements.removeAll()
                    }, onCollapse: {
                        document.toggleCollapsed(table)
                    }, onBeginLinkDrag: { column, startPoint in
                        linkDrag = LinkDrag(
                            fromColumnID: column.id,
                            startPoint: startPoint,
                            currentPoint: startPoint
                        )
                    },
                    onUpdateLinkDrag: { point in
                        linkDrag?.currentPoint = point
                    },
                    onEndLinkDrag: { endPoint in
                        guard let drag = linkDrag else { return }
                        linkDrag = nil
                        document.layout.makeColumnHighlighted(id: nil)
                        
                        guard let targetColumn = document.layout.columnIDAt(endPoint) else { return }
                        
                        document.createRelation(from: drag.fromColumnID, to: targetColumn)
                    }
                )
                .offset(x: table.position.minX, y: table.position.minY)
                .modifier(DragModifier(location: $table.position.origin, layout: layout, document: document))
            }
            
            if let drag = linkDrag {
                Path { path in
                    path.move(to: drag.startPoint)
                    path.addEllipse(in: CGRect(
                        x: drag.startPoint.x - 5,
                        y: drag.startPoint.y - 5,
                        width: 10, height: 10))
                    
                    path.addLine(to: drag.currentPoint)
                    path.addEllipse(in: CGRect(
                        x: drag.currentPoint.x - 5,
                        y: drag.currentPoint.y - 5,
                        width: 10, height: 10))
                }
                .stroke(Color.accentColor, lineWidth: 2)
                .fill(Color.accentColor)
                .onChange(of: drag) {
                    document.layout.makeColumnHighlighted(id: document.layout.columnIDAt(drag.currentPoint))
                }
            }
        }
        .coordinateSpace(.named("graph"))
        .onPreferenceChange(ColumnGeometryKey.self) { frames in
            DispatchQueue.main.async {
                document.layout.columnFrames.merge(frames, uniquingKeysWith: { $1 })
            }
        }
        .onModifierKeysChanged { old, new in
            document.layout.modifierKeys = new
        }
    }
}
