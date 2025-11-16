//
//  ToolWindowController.swift
//  DBEdit
//
//  Created by Vito Sartori on 15/11/25.
//


import SwiftUI

final class ToolWindowController<Content: View>: NSWindowController {
    convenience init(title: String, size: CGSize, @ViewBuilder content: () -> Content) {
        let hosting = NSHostingController(rootView: content())
        
        hosting.view.frame = NSRect(origin: .zero, size: size)
        hosting.view.autoresizingMask = [.width, .height]
        
        let panel = NSPanel(
            contentRect: NSRect(origin: .zero, size: size),
            styleMask: [
                .titled,
                .utilityWindow,
                .closable,
                .resizable,
                .nonactivatingPanel
            ],
            backing: .buffered,
            defer: false
        )
        
        panel.title = title
        
        panel.isFloatingPanel = true
        panel.becomesKeyOnlyIfNeeded = true
        panel.hidesOnDeactivate = false
        panel.level = .floating
        
        panel.titleVisibility = .visible
        panel.titlebarAppearsTransparent = true
        panel.isMovableByWindowBackground = true
        
        panel.contentViewController = hosting
        panel.setContentSize(size)
        panel.contentMinSize = size
        
        self.init(window: panel)
    }
}
