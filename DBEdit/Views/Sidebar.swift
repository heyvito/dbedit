//
//  Sidebar.swift
//  DBEdit
//
//  Created by Vito Sartori on 15/11/25.
//

import SwiftUI

struct Sidebar: View {
    @ObservedObject var document: SchemaDocument
    @State private var selection: SidebarSelection?
    
    enum SidebarSelection: Hashable {
        case table(Table.ID)
        case enumType(EnumType.ID)
    }
    
    var body: some View {
        List(selection: $selection) {
            // MARK: - Tables
            Section("Tables") {
                ForEach(document.schema.tables) { table in
                    Label {
                        Text(table.name)
                            .monospaced()
                    } icon: {
                        Image(systemName: "tablecells")
                    }
                    .tag(SidebarSelection.table(table.id))
                }
            }

            Section("Enums") {
                ForEach(document.schema.enums) { enumType in
                    Label {
                        Text(enumType.name)
                            .monospaced()
                    } icon: {
                        Image(systemName: "square.grid.2x2")
                    }
                    .tag(SidebarSelection.enumType(enumType.id))
                }
            }
        }
        .listStyle(.sidebar)
        .scrollContentBackground(.hidden)
    }
}
