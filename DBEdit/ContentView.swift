//
//  ContentView.swift
//  DBEdit
//
//  Created by Vito Sartori on 14/11/25.
//

import SwiftUI

struct DragModifier: ViewModifier {
    @Binding var location: CGPoint
    @State private var startPoint: CGPoint?

    func body(content: Content) -> some View {
        content
            .gesture(DragGesture().onChanged { value in
                if startPoint == nil {
                    startPoint = location
                }
                location = startPoint! + value.translation
            }.onEnded({ value in
                startPoint = nil
            }))
    }
}

struct ResizeModifier: ViewModifier {
    var enabled: Bool
    @Binding var frame: CGRect
    var positions: [UnitPoint] = [
        .topLeading, .top, .topTrailing,
        .leading, .trailing,
        .bottomLeading, .bottom, .bottomTrailing
    ]


    func body(content: Content) -> some View {
        content
            .overlay {
                if enabled {
                    ForEach(positions, id: \.self) { point in
                        ResizeHandle(frame: $frame, point: point)
                    }
                }
            }
    }
}

struct ResizeHandle: View {
    @Binding var frame: CGRect
    var point: UnitPoint
    @State var startPoint: CGPoint? = nil

    var body: some View {
        Rectangle()
            .fill(.white)
            .stroke(.black)
            .frame(width: 6, height: 6)
            .position(frame[point])
            .gesture(DragGesture(minimumDistance: 0)
                .onChanged({ value in
                    guard let startPoint else {
                        startPoint = value.location
                        return
                    }
                    frame[point] = startPoint + value.translation
                }).onEnded({ _ in
                    startPoint = nil
                })
            )
    }
}

struct NodeView: View {
    var node: Node
    var isSelected: Bool

    var body: some View {
        Rectangle()
            .fill(.background)
            .stroke(isSelected ? Color.accentColor : Color.primary, lineWidth: 2)
            .frame(width: node.frame.width, height: node.frame.height)
            .overlay {
//                Text(node.title)
                TextField("Title", text: .constant(node.title))
            }
            .focusable()
            .focusEffectDisabled()
    }
}

struct EdgeView: View {
    var edge: ResolvedEdge
    let minOffset: CGFloat = 50
    var body: some View {
        Path { p in
            p.move(to: edge.from)
            var cp1 = edge.from
            let diffX = max(minOffset, abs(edge.to.x - edge.from.x))
            cp1.x +=  diffX * 0.5
            var cp2 = edge.to
            cp2.x -= diffX * 0.5
            p.addCurve(to: edge.to, control1: cp1, control2: cp2)
        }
        .stroke(Color.accentColor, lineWidth: 2)
    }
}

enum FocusedElement: Hashable {
    case node(Node.ID)
    case edge(Edge.ID)
}

extension Set {
    subscript(contains element: Element) -> Bool {
        get {
            contains(element)
        }
        set {
            if newValue {
                self.insert(element)
            } else {
                self.remove(element)
            }
        }
    }
}

struct GraphView: View {
    @Binding var graph: Graph
    @FocusState private var focusedElement: FocusedElement?
    @State private var selection = Set<Node.ID>()
    @State private var modifiers: EventModifiers = []

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.clear
                .contentShape(.rect)
                .onTapGesture {
                    focusedElement = nil
                    selection = []
                }
            ForEach(graph.edges) { edge in
                let result = graph.resolve(edge: edge)
                EdgeView(edge: result)
                    .focusable()
                    .focused($focusedElement, equals: .edge(edge.id))
            }
            ForEach($graph.nodes) { $node in
                NodeView(node: node, isSelected: selection[contains: node.id])
                    .offset(x: node.frame.minX, y: node.frame.minY)
                    .modifier(DragModifier(location: $node.frame.origin))
                    .focused($focusedElement, equals: .node(node.id))
                    .modifier(ResizeModifier(enabled: selection[contains: node.id], frame: $node.frame))
                    .onTapGesture {
                        if !modifiers.contains(.shift) {
                            selection.removeAll()
                        }

                        selection.insert(node.id)
                    }
            }
        }
        .overlay { Text("\(focusedElement)") }
        .onModifierKeysChanged { old, new in
            self.modifiers = new
        }
        .onChange(of: focusedElement) { _, newValue in
            guard case let .node(id) = newValue else { return }
            if !modifiers.contains(.shift) {
                selection.removeAll()
            }
            selection.insert(id)
        }
    }
}

var exampleGraph: Graph {
    var result = Graph(nodes: [
        .init(title: "Foo", frame: .init(origin: .zero, size: .init(width: 100, height: 40))),
        .init(title: "Bar", frame: .init(origin: .init(x: 100, y: 80), size: .init(width: 120, height: 80))),
        .init(title: "Baz", frame: .init(origin: .init(x: 100, y: 80), size: .init(width: 120, height: 80))),
    ], edges: [])

    result.edges.append(.init(source: result.nodes[0].id, destination: result.nodes[1].id))
    result.edges.append(.init(source: result.nodes[0].id, destination: result.nodes[2].id))

    return result
}

struct ContentView: View {
    @State var graph = exampleGraph
    var body: some View {
        GraphView(graph: $graph)
            .padding()
    }
}

#Preview {
    ContentView()
}
