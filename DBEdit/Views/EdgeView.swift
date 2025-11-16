//
//  EdgeView.swift
//  DBEdit
//
//  Created by Vito Sartori on 15/11/25.
//

import SwiftUI

struct EdgeView: View {
    var edge: ResolvedEdge
    let minOffset: CGFloat = 50
    let minHorizontal: CGFloat = 40     // horizontal curve for L→R
    let minSameSide: CGFloat = 20       // horizontal bump for L→L or R→R

    var body: some View {
        ZStack {
            Path { p in
                p.move(to: edge.from)

                let dx = edge.to.x - edge.from.x
                let dy = abs(edge.to.y - edge.from.y)

                var cp1 = edge.from
                var cp2 = edge.to

                switch (edge.fromAttachment, edge.toAttachment) {

                // MARK: Cross sides (normal case)
                case (.trailing, .leading):
                    let bump = max(minHorizontal, abs(dx)) * 0.5
                    cp1.x += bump
                    cp2.x -= bump

                case (.leading, .trailing):
                    let bump = max(minHorizontal, abs(dx)) * 0.5
                    cp1.x -= bump
                    cp2.x += bump

                // MARK: Same side (special case)
                case (.leading, .leading):
                    let bump = max(minSameSide, dy * 0.3)
                    cp1.x -= bump
                    cp2.x -= bump

                case (.trailing, .trailing):
                    let bump = max(minSameSide, dy * 0.3)
                    cp1.x += bump
                    cp2.x += bump

                default:
                    break
                }

                p.addCurve(to: edge.to, control1: cp1, control2: cp2)
            }
            .stroke(Color.accentColor, lineWidth: 2)
            Path { p in
                p.addEllipse(in: CGRect(
                    x: edge.from.x - 5,
                    y: edge.from.y - 5,
                    width: 10, height: 10))
                p.addEllipse(in: CGRect(
                    x: edge.to.x - 5,
                    y: edge.to.y - 5,
                    width: 10, height: 10))
            }.fill(Color.accentColor)
        }
    }
}
