//
//  TableGraphView.swift
//  DBEdit
//
//  Created by Vito Sartori on 14/11/25.
//

import SwiftUI

struct TableGraphView: View {
    var table: Table

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Text(table.name)
                    .monospaced()
                    .foregroundStyle(table.color.readableTextColor())
                Spacer()
            }
            .padding(8)
            .background { table.color }
            VStack {
                ForEach(table.columns) { column in
                    HStack {
                        Image(systemName: column.icon)
                            .frame(minWidth: 20, maxWidth: 20)
                        Text(column.name)
                            .monospaced()
                        Spacer()
                        Text(column.type.name)
                            .monospaced()
                            .foregroundStyle(.secondary)
                    }.padding(1)
                }
            }.padding([.leading, .trailing, .bottom], 8)
        }
            .clipShape(.rect(cornerRadius: 6)) // shorthand for RoundedRectangle(cornerRadius: 6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(table.color, lineWidth: 1)
                )
    }
}

#Preview {
    TableGraphView(table: exampleSchema.tables[1])
        .padding()
}
