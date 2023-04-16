//
//  PieSliceView.swift
//
//
//  Created by Nazar Ilamanov on 4/23/21.
//

import SwiftUI

// MARK: - PieSlice

@available(OSX 10.15, *)
struct PieSlice: View {
    var pieSliceData: PieSliceData

    var midRadians: Double {
        Double.pi / 2.0 - (pieSliceData.startAngle + pieSliceData.endAngle)
            .radians / 2.0
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Path { path in
                    let width: CGFloat = min(
                        geometry.size.width,
                        geometry.size.height
                    )
                    let height = width
                    path.move(
                        to: CGPoint(
                            x: width * 0.5,
                            y: height * 0.5
                        )
                    )

                    path.addArc(
                        center: CGPoint(x: width * 0.5, y: height * 0.5),
                        radius: width * 0.5,
                        startAngle: Angle(degrees: -90.0) + pieSliceData
                            .startAngle,
                        endAngle: Angle(degrees: -90.0) + pieSliceData.endAngle,
                        clockwise: false
                    )
                }
                .fill(pieSliceData.color)

                if !pieSliceData.isIgnored {
                    Text(pieSliceData.text)
                        .position(
                            x: geometry.size
                                .width * 0.5 *
                                CGFloat(1.0 + 0.78 * cos(midRadians)),
                            y: geometry.size
                                .height * 0.5 *
                                CGFloat(1.0 - 0.78 * sin(midRadians))
                        )
                        .foregroundColor(Color.white)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

// MARK: - PieSliceData

@available(OSX 10.15, *)
struct PieSliceData {
    var startAngle: Angle
    var endAngle: Angle
    var text: String
    var color: Color
    var isIgnored: Bool = false
}

// MARK: - PieSlice_Previews

@available(OSX 10.15.0, *)
struct PieSlice_Previews: PreviewProvider {
    static var previews: some View {
        PieSlice(pieSliceData: PieSliceData(
            startAngle: Angle(degrees: 0.0),
            endAngle: Angle(degrees: 120.0),
            text: "30%",
            color: Color.black
        ))
    }
}
