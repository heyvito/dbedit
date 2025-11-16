//
//  DBEditApp.swift
//  DBEdit
//
//  Created by Vito Sartori on 14/11/25.
//

import SwiftUI

@main
struct DBEditApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: exampleSchemaDocument) { file in
            MainContentView(document: file.document)
        }
        .windowStyle(.titleBar)
        .windowToolbarStyle(.unifiedCompact)
    }
}
