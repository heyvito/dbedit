//
//  Modifiers.swift
//  DBEdit
//
//  Created by Vito Sartori on 15/11/25.
//

import SwiftUI


struct DragModifier: ViewModifier {
    @Binding var location: CGPoint
    @ObservedObject var layout: SchemaLayout
    @ObservedObject var document: SchemaDocument
    @State private var startPoint: CGPoint?

    func body(content: Content) -> some View {
        content
            .gesture(DragGesture().onChanged { value in
                if startPoint == nil {
                    startPoint = location
                }

                let startLocation = location
                let newLocation = startPoint! + value.translation
                let delta = newLocation - startLocation

                for el in layout.selectedElements {
                    document.repositionTableWithID(el, by: delta)
                }

                location = newLocation

            }.onEnded({ value in
                startPoint = nil
            }))
    }
}

struct SelectionGlow: ViewModifier {
    let active: Bool

    func body(content: Content) -> some View {
        content
            .shadow(color: active ? Color.accentColor.opacity(0.45) : .clear,
                    radius: 8)
            .shadow(color: active ? Color.accentColor.opacity(0.25) : .clear,
                    radius: 16)
    }
}
