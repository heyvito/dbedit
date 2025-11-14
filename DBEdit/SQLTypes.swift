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

struct Column {
    var name: String
    var type: PGType
    var isPrimaryKey: Bool
    var isNullable: Bool
    var isUnique: Bool
    var defaultValue: String?
}

struct Table {
    var name: String
    var color: Color
    var schema: String?

}
