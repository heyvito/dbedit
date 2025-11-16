//
//  VisualEffectSidebar.swift
//  DBEdit
//
//  Created by Vito Sartori on 15/11/25.
//


import SwiftUI

struct VisualEffectSidebar: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let v = NSVisualEffectView()
        v.blendingMode = .behindWindow
        v.material = .sidebar
        v.state = .active
        return v
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}
