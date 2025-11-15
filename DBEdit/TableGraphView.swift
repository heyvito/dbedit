//
//  TableGraphView.swift
//  DBEdit
//
//  Created by Vito Sartori on 14/11/25.
//

import SwiftUI

struct TableGraphView: View {
    @Binding var table: Table
    var onClickTable: ((_ table: Table) -> Void)? = nil
    var onClickColumn: ((_ column: Column) -> Void)? = nil
    var onCollapse: ((_ table: Table) -> Void)? = nil
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
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Text(table.name)
                        .monospaced()
                        .foregroundStyle(table.color.readableTextColor())
                    Spacer()
                    Button {
                        onCollapse?(table)
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
                
                VStack {
                    ForEach(table.columns) { column in
                        VStack {
                            HStack {
                                Image(systemName: column.icon)
                                    .frame(minWidth: 20, maxWidth: 20)
                                Text(column.name)
                                    .monospaced()
                                Spacer()
                                Text(column.type.name)
                                    .monospaced()
                                    .foregroundStyle(.secondary)
                            }
                            .padding([.leading, .trailing], 8)
                            .padding([.top, .bottom], 1)
                            
                            Rectangle()
                                .fill(table.color)
                                .frame(height: 0.5)
                        }
                        .gesture(
                            DragGesture(minimumDistance: 0, coordinateSpace: .named("graph"))
                                .modifiers(.control)
                                .onChanged { value in
                                    if value.translation == .zero {
                                        // first event
                                        onBeginLinkDrag?(column, value.startLocation)
                                    }
                                    onUpdateLinkDrag?(value.location)
                                }
                                .onEnded { value in
                                    onEndLinkDrag?(value.location)
                                }
                        )
                        .onTapGesture {
                            onClickColumn?(column)
                        }
                    }
                }
            }
            .onTapGesture {
                onClickTable?(table)
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
        }

        private func updateSizeIfNeeded(_ newSize: CGSize) {
            // Avoid useless updates / layout loops
            guard table.position.size != newSize else { return }

            // Mutating bindings during layout can trigger a warning,
            // so push it to the next runloop tick.
            DispatchQueue.main.async {
                table.position.size = newSize
            }
        }
}

#Preview {
    ZStack {
        Color.red
        TableGraphView(table: .constant(exampleSchema.tables[1]))
            .padding()
    }
}
