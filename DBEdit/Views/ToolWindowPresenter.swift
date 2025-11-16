//
//  ToolWindowPresenter.swift
//  DBEdit
//
//  Created by Vito Sartori on 15/11/25.
//

import SwiftUI

struct ToolWindowPresenter<Content: View>: NSViewRepresentable {
    @Binding var isPresented: Bool
    let title: String
    let size: CGSize
    let content: () -> Content

    class Coordinator {
        var controller: NSWindowController?
    }

    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeNSView(context: Context) -> NSView { NSView() }

    func updateNSView(_ nsView: NSView, context: Context) {
        if isPresented {
            if context.coordinator.controller == nil {
                let controller = ToolWindowController(
                    title: title,
                    size: size,
                    content: content
                )
                context.coordinator.controller = controller
                controller.showWindow(nil)
                controller.window?.center()
            } else {
                context.coordinator.controller?.showWindow(nil)
            }
        } else {
            context.coordinator.controller?.close()
            context.coordinator.controller = nil
        }
    }
}
