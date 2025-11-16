//
//  SchemaStore.swift
//  DBEdit
//
//  Created by Vito Sartori on 15/11/25.
//

import SwiftUI
import Combine
import UniformTypeIdentifiers

final class SchemaDocument: ObservableObject, FileDocument {
    static var readableContentTypes: [UTType] = [.json] 

    @Published var schema: Schema
    @Published var layout: SchemaLayout

    init(schema: Schema = Schema(name: "Untitled")) {
        self.schema = schema
        self.layout = .init()
    }

    init(configuration: ReadConfiguration) throws {
        self.schema = exampleSchema
        self.layout = .init()
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: Data())
    }

    func tableForColumn(id: Column.ID) -> Table? {
        schema.tables.first(where: { $0.columns.contains(where: { $0.id == id }) })
    }

    func column(id: Column.ID) -> Column? {
        return schema.tables.flatMap(\.columns).first(where: { $0.id == id })
    }

    func createRelation(from: Column.ID, to: Column.ID) {
        guard let toTable = tableForColumn(id: to),
              let toColumn = toTable.columns.first(where: { $0.id == to }) else { return }
        
        withTable(forColumn: from) { fromTable in
            guard let fromColumn = fromTable.columns.first(where: { $0.id == from }) else { return }
            fromTable.foreignKeys.append(
                .init(
                    columns: [fromColumn.id],
                    referencesTable: toTable.id,
                    referencesColumns: [toColumn.id]
                )
            )
        }
    }

    func toggleCollapsed(_ table: Table) {
        withTable(table) { tab in
            tab.isCollapsed.toggle()
        }
    }

    func repositionTableWithID(_ id: Table.ID, by: CGPoint) {
        withTable(id) { tab in
            tab.position.origin += by
        }
    }

    private func withTable(forColumn id: Column.ID, _ body: (inout Table) -> Void) {
        guard let idx = schema.tables.firstIndex(where: { $0.columns.contains(where: { $0.id == id }) }) else { return }
        body(&schema.tables[idx])
    }

    private func withTable(_ table: Table, _ body: (inout Table) -> Void) {
        guard let idx = schema.tables.firstIndex(where: { $0.id == table.id }) else { return }
        body(&schema.tables[idx])
    }

    private func withTable(_ id: Table.ID, _ body: (inout Table) -> Void) {
        guard let idx = schema.tables.firstIndex(where: { $0.id == id }) else { return }
        body(&schema.tables[idx])
    }
}

var exampleSchemaDocument = SchemaDocument(schema: exampleSchema)
