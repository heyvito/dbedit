//
//  ContentView.swift
//  DBEdit
//
//  Created by Vito Sartori on 14/11/25.
//

import SwiftUI
import Combine

struct MainContentView: View {
    @ObservedObject var document: SchemaDocument

    var body: some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigation) {

                }

                ToolbarItemGroup(placement: .automatic) {
                    Button {
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .toolWindow(
                isPresented: .constant(true),
                title: "Debug View",
                size: .init(width: 320, height: 300)
            ) {
                DebugView(layout: document.layout)
                    .padding()
            }
    }


    var content: some View {
        GeometryReader { proxy in
            HSplitView {
                Sidebar(document: document)
                    .frame(minWidth: 200, maxHeight: .infinity)
                    .background(VisualEffectSidebar())

                GraphView(document: document, layout: document.layout)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                Inspector(document: document)
                    .frame(minWidth: 200, maxHeight: .infinity)
                    .background(VisualEffectSidebar())
            }
            .frame(
                width: proxy.size.width,
                height: proxy.size.height
            )
        }
        .frame(minWidth: 900, minHeight: 600)
    }
}

#Preview {
    MainContentView(document: exampleSchemaDocument)
}
