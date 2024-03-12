//
//  ChartsView.swift
//  project
//
//  Created by admin on 3/11/24.
//

import SwiftUI
import Charts

struct ToyShape: Identifiable {
    var type: String
    var count: Double
    var id = UUID()
}


var data: [ToyShape] = [
    .init(type: "Cube", count: 5),
    .init(type: "Sphere", count: 4),
    .init(type: "Pyramid", count: 4)
]

struct ChartsView: View {
    var body: some View {
        Chart {
            BarMark(
                    x: .value("Shape Type", data[0].type),
                    y: .value("Total Count", data[0].count)
                )
                BarMark(
                     x: .value("Shape Type", data[1].type),
                     y: .value("Total Count", data[1].count)
                )
                BarMark(
                     x: .value("Shape Type", data[2].type),
                     y: .value("Total Count", data[2].count)
                )
        }
    }
}

#Preview {
    ChartsView()
}
