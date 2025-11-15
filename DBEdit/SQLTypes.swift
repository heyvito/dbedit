//
//  SQLTypes.swift
//  DBEdit
//
//  Created by Vito Sartori on 14/11/25.
//

import SwiftUI

indirect enum PGType {
    case smallint
    case integer
    case bigint
    case decimal
    case real
    case double
    case serial
    case bigserial
    case smallserial
    case money
    case text
    case varchar(size: Int)
    case char(size: Int)
    case citext
    case boolean
    case timestamp
    case timestamptz
    case date
    case time
    case timetz
    case interval
    case bytea
    case uuid
    case json
    case jsonb
    case point
    case line
    case lseg
    case box
    case path
    case polygon
    case circle
    case cidr
    case inet
    case macaddr
    case macaddr8
    case custom(name: String)
    case array(of: PGType)
    case int4range
    case int8range
    case numrange
    case tsrange
    case tstzrange
    case daterange
    case tsvector
    case tsquary
    case xml
    case jsonpath
    case geometry
    case geography
    case topogeometry
    case raster
    case hstore
    case ltree
    case ltquery
    case ltxtquery
}

extension PGType {
    var icon: String {
        switch self {
        case .smallint, .integer, .bigint, .decimal, .real, .double, .serial, .bigserial, .smallserial:
            return "numbers"
        case .money:
            return "dollarsign"
        case .text, .varchar(size: _), .char(size: _), .citext:
            return "textformat.alt"
        case .boolean:
            return "checkmark.square"
        case .timestamp, .timestamptz:
            return "calendar.badge.clock"
        case .date:
            return "29.calendar"
        case .time, .timetz, .interval:
            return "clock"
        case .bytea:
            return "01.square"
        case .uuid:
            return "barcode"
        case .json, .jsonb, .jsonpath:
            return "curlybraces"
        case .xml:
            return "xml"
        case .point:
            return "scope"
        case .line:
            return "line.diagonal"
        case .lseg:
            return "arrow.trianglehead.branch"
        case .box:
            return "square"
        case .path:
            return "point.topleft.down.to.point.bottomright.curvepath.fill"
        case .polygon:
            return "octagon"
        case .circle:
            return "circle"
        case .cidr:
            return "network"
        case .inet:
            return "globe"
        case .macaddr, .macaddr8:
            return "lanyardcard"
        case .array(of: _):
            return "list"
        case .int4range, .int8range, .numrange, .tsrange, .tstzrange, .daterange:
            return "arrow.left.and.right.square"
        case .tsvector:
            return "text.alignleft"
        case .tsquary:
            return "text.page.badge.magnifyingglass"
        case .hstore:
            return "list.bullet.rectangle.portrait"
        case .geometry:
            return "square.grid.3x3"
        case .geography:
            return "globe.americas.fill"
        case .topogeometry:
            return "point.topleft.down.to.point.bottomright.curvepath"
        case .raster:
            return "square.grid.2x2"
        case .ltree:
            return "tree"
        case .ltquery, .ltxtquery:
            return "magnifyingglass"
        case .custom(name: _):
            return "sparkles"
        }
    }
    var name: String {
        switch self {
        case .smallint:
            return "smallint"
        case .integer:
            return "integer"
        case .bigint:
            return "bigint"
        case .decimal:
            return "decimal"
        case .real:
            return "real"
        case .double:
            return "double"
        case .serial:
            return "serial"
        case .bigserial:
            return "bigserial"
        case .smallserial:
            return "smallserial"
        case .money:
            return "money"
        case .text:
            return "text"
        case .varchar(size: let s):
            return "varchar(\(s))"
        case .char(size: let s):
            return "char(\(s))"
        case .citext:
            return "citext"
        case .boolean:
            return "boolean"
        case .timestamp:
            return "timestamp"
        case .timestamptz:
            return "timestamptz"
        case .date:
            return "date"
        case .time:
            return "time"
        case .timetz:
            return "timetz"
        case .interval:
            return "interval"
        case .bytea:
            return "bytea"
        case .uuid:
            return "uuid"
        case .json:
            return "json"
        case .jsonb:
            return "jsonb"
        case .point:
            return "point"
        case .line:
            return "line"
        case .lseg:
            return "lseg"
        case .box:
            return "box"
        case .path:
            return "path"
        case .polygon:
            return "polygon"
        case .circle:
            return "circle"
        case .cidr:
            return "cidr"
        case .inet:
            return "inet"
        case .macaddr:
            return "macaddr"
        case .macaddr8:
            return "macaddr8"
        case .custom(name: let n):
            return n
        case .array(of: let t):
            return "array(\(t.name))"
        case .int4range:
            return "int4range"
        case .int8range:
            return "int8range"
        case .numrange:
            return "numrange"
        case .tsrange:
            return "tsrange"
        case .tstzrange:
            return "tstzrange"
        case .daterange:
            return "daterange"
        case .tsvector:
            return "tsvector"
        case .tsquary:
            return "tsquary"
        case .xml:
            return "xml"
        case .jsonpath:
            return "jsonpath"
        case .geometry:
            return "geometry"
        case .geography:
            return "geography"
        case .topogeometry:
            return "topogeometry"
        case .raster:
            return "raster"
        case .hstore:
            return "hstore"
        case .ltree:
            return "ltree"
        case .ltquery:
            return "ltquery"
        case .ltxtquery:
            return "ltxtquery"
        }
    }
}

struct Column: Identifiable {
    var id: UUID = UUID()
    var name: String
    var type: PGType
    var isPrimaryKey: Bool = false
    var isNullable: Bool = false
    var isUnique: Bool = false
    var defaultValue: String? = nil

    var icon: String {
        if isPrimaryKey {
            return "key.horizontal.fill"
        }
        return type.icon
    }
}

enum FKAction: String {
    case noAction = "NO ACTION"
    case restrict = "RESTRICT"
    case cascade = "CASCADE"
    case setNull = "SET NULL"
    case setDefault = "SET DEFAULT"
}

enum IndexColumn {
    case column(
        name: String,
        collation: String?,
        opclass: String?,
        ordering: SortOrder?
    )
    case expression(sql: String)
}

enum SortOrder {
    case asc
    case desc
    case nullsFirst
    case nullsLast
}

enum IndexMethod: String {
    case btree
    case hash
    case gin
    case gist
    case spgist
    case brin
}

struct ForeignKey {
    var columns: [Column.ID]
    var referencesSchema: String? = nil
    var referencesTable: Table.ID
    var referencesColumns: [Column.ID]
    var onUpdate: FKAction = .noAction
    var onDelete: FKAction? = .noAction
}

enum ConstraintType {
    case primaryKey
    case foreignKey
    case unique
    case check
    case exclusion
}

struct Constraint: Identifiable {
    let id: UUID = UUID()

    var name: String?
    var type: ConstraintType
    var columns: [Column.ID]
    var definition: String?
    var referencedTable: Table.ID?
    var referencedSchema: String?
    var referencedColumns: [Column.ID]?
    var onUpdate: FKAction?
    var onDelete: FKAction?
}

struct Index: Identifiable {
    let id: UUID = UUID()

    var name: String
    var method: IndexMethod = .btree
    var columns: [IndexColumn]
    var isUnique: Bool = false
    var isPrimary: Bool = false
    var isPartial: Bool = false
    var predicate: String? = nil
    var isValid: Bool = false
    var isClustered: Bool = false
}

struct Table: Identifiable {
    var id: UUID = UUID()

    var name: String
    var color: Color = .white
    var schema: String? = nil
    var columns: [Column] = []
    var position: CGRect = .zero
    var isCollapsed: Bool = false
    var comment: String = ""
    var primaryKey: [Column.ID] = []
    var foreignKeys: [ForeignKey] = []
    var constraints: [Constraint] = []
}

struct EnumType: Identifiable {
    let id: UUID = UUID()

    var name: String
    var schema: String? = nil
    var labels: [String] = []
    var comment: String? = nil
    var color: Color? = nil
    var isCollapsed: Bool = false
}

struct Schema {
    var name: String
    var tables: [Table] = []
    var Enums: [EnumType] = []
}

var exampleSchema: Schema {
    var sc = Schema(name: "airgate")

    sc.tables.append(Table(
        name: "organizations",
        columns: [
            .init(name: "id", type: .uuid, isPrimaryKey: true, isUnique: true),
            .init(name: "name", type: .text, isNullable: false),
            .init(name: "active", type: .boolean, isNullable: false, defaultValue: "TRUE"),
            .init(name: "default_permissions", type: .json, isNullable: true),
            .init(name: "requires_2fa", type: .boolean, isNullable: false, defaultValue: "FALSE"),
            .init(name: "requires_u2f", type: .boolean, isNullable: false, defaultValue: "FALSE"),
            .init(name: "session_timeout_seconds", type: .integer, isNullable: false, defaultValue: "86400"),
            .init(name: "created_at", type: .timestamptz, defaultValue: "NOW()"),
            .init(name: "updated_at", type: .timestamptz, defaultValue: "NOW()")
        ]
    ))

    sc.tables.append(Table(
        name: "org_session_keys",
        columns: [
            .init(name: "id", type: .uuid, isPrimaryKey: true, isUnique: true),
            .init(name: "organization_id", type: .uuid, isNullable: false),
            .init(name: "private_key", type: .bytea, isNullable: false),
            .init(name: "public_key", type: .bytea, isNullable: false),
            .init(name: "created_at", type: .timestamptz, defaultValue: "NOW()"),
            .init(name: "updated_at", type: .timestamptz, defaultValue: "NOW()")
        ]
    ))

    sc.tables[1].foreignKeys = [
        .init(columns: [sc.tables[1].columns[1].id], referencesTable: sc.tables[0].id, referencesColumns: [sc.tables[0].columns[0].id])
    ]

    return sc
}
