//
//  ScrollableContainer.swift
//  DBEdit
//
//  Created by Vito Sartori on 15/11/25.
//

import SwiftUI

struct ScrollableContainer<Content: View>: NSViewRepresentable {
    var onScroll: (CGFloat, CGFloat) -> Void   // dx, dy
    var content: () -> Content

    func makeNSView(context: Context) -> ContainerView<Content> {
        let view = ContainerView(rootView: content())
        view.onScroll = onScroll
        return view
    }

    func updateNSView(_ nsView: ContainerView<Content>, context: Context) {
        nsView.onScroll = onScroll
        nsView.hosting.rootView = content()
    }
}

final class ContainerView<Content: View>: NSView {
    let hosting: NSHostingView<Content>
    var onScroll: ((CGFloat, CGFloat) -> Void)?

    init(rootView: Content) {
        hosting = NSHostingView(rootView: rootView)
        super.init(frame: .zero)

        addSubview(hosting)
        hosting.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            hosting.leadingAnchor.constraint(equalTo: leadingAnchor),
            hosting.trailingAnchor.constraint(equalTo: trailingAnchor),
            hosting.topAnchor.constraint(equalTo: topAnchor),
            hosting.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func scrollWheel(with event: NSEvent) {
        onScroll?(event.scrollingDeltaX, event.scrollingDeltaY)

        // DO NOT call super, don't forward – we own scroll for panning.
    }
}
