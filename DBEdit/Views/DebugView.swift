//
//  DebugView.swift
//  DBEdit
//
//  Created by Vito Sartori on 15/11/25.
//

import SwiftUI

struct DebugView: View {
    @ObservedObject var layout: SchemaLayout

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("higlightedColumnID:")
                    .monospaced()
                Text("\(layout.higlightedColumnID?.uuidString ?? "<nil>")")
            }
            HStack {
                Text("focusedElement:")
                    .monospaced()
                Text("\(layout.focusedElement)")
            }
            HStack {
                Text("selectedElements:")
                    .monospaced()
                Text("\(layout.selectedElements)")
            }
        }
    }
}
