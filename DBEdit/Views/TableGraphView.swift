//
//  TableGraphView.swift
//  DBEdit
//
//  Created by Vito Sartori on 14/11/25.
//

import SwiftUI

struct TableGraphView: View {
    @Binding var table: Table
    @ObservedObject var layout: SchemaLayout
    var onClick: (() -> Void)? = nil
    var onClickColumn: ((_ column: Column) -> Void)? = nil
    var onCollapse: (() -> Void)? = nil
    var onBeginLinkDrag: ((_ column: Column, _ startPoint: CGPoint) -> Void)? = nil
    var onUpdateLinkDrag: ((_ point: CGPoint) -> Void)? = nil
    var onEndLinkDrag: ((_ point: CGPoint) -> Void)? = nil

    var body: some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            updateSizeIfNeeded(proxy.size)
                        }
                        .onChange(of: proxy.size) { _, newSize in
                            updateSizeIfNeeded(newSize)
                        }
                }
            )
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                Text(table.name)
                    .monospaced()
                    .foregroundStyle(table.color.readableTextColor())
                Spacer()
                Button {
                    onCollapse?()
                } label: {
                    let imageName = table.isCollapsed ? "chevron.up" : "chevron.down"
                    Image(systemName: imageName)
                        .font(.system(size: 16))
                        .foregroundStyle(table.color.readableTextColor())
                }
                .buttonStyle(.plain)
            }
            .padding(8)
            .background { table.color }

            VStack(spacing: 0) {
                if (!table.isCollapsed) {
                    ForEach(table.columns) { column in
                        VStack(spacing: 0) {
                            HStack {
                                Image(systemName: column.icon)
                                    .frame(minWidth: 20, maxWidth: 20)
                                Text(column.name)
                                    .monospaced()
                                Spacer(minLength: 32)
                                Text(column.type.name)
                                    .monospaced()
                                    .foregroundStyle(.secondary)
                            }
                            .padding([.leading, .trailing], 8)
                            .padding([.top, .bottom], 8)

                            Rectangle()
                                .fill(table.color)
                                .frame(height: 0.5)
                        }
                        .reportColumnFrame(id: column.id)
                        .background {
                            if layout.higlightedColumnID == column.id {
                                Rectangle().fill(table.color.opacity(0.3))
                            } else if case .column(let id) = layout.focusedElement, id == column.id {
                                Rectangle().fill(Color.accentColor)
                            } else {
                                Rectangle().fill(.windowBackground)
                            }
                        }
                        .gesture(
                            DragGesture(minimumDistance: 0, coordinateSpace: .named("graph"))
                                .modifiers(.control)
                                .onChanged { value in
                                    if value.translation == .zero {
                                        onBeginLinkDrag?(column, value.startLocation)
                                    }
                                    onUpdateLinkDrag?(value.location)
                                }
                                .onEnded { value in
                                    onEndLinkDrag?(value.location)
                                }
                        )
                        .onTapGesture {
                            if (layout.modifierKeys.contains(.shift)) {
                                onClick?()
                            } else {
                                onClickColumn?(column)
                            }
                        }
                    }
                }
            }
        }
        .onTapGesture {
            onClick?()
        }
        .background {
            Rectangle().fill(.windowBackground)
        }
        .clipShape(.rect(cornerRadius: 6))
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(table.color, lineWidth: 1)
        )
        .fixedSize()
        .shadow(radius: 4)
        .modifier(SelectionGlow(active: layout.selectedElements.contains(table.id)))
    }

    private func updateSizeIfNeeded(_ newSize: CGSize) {
        guard table.position.size != newSize else { return }
        DispatchQueue.main.async {
            table.position.size = newSize
        }
    }
}

#Preview {
    ZStack {
        Color.red
        TableGraphView(
            table: .constant(exampleSchemaDocument.schema.tables[1]),
            layout: exampleSchemaDocument.layout
        )
        .padding()
    }
}
