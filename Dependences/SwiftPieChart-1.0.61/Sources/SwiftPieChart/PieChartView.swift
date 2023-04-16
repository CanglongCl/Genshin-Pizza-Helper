//
//  PieChartView.swift
//
//
//  Created by Nazar Ilamanov on 4/23/21.
//

import SwiftUI

// MARK: - PieChartView

@available(OSX 10.15, *)
public struct PieChartView: View {
    // MARK: Lifecycle

    public init(
        values: [Double],
        names: [String],
        formatter: @escaping (Double) -> String,
        colors: [Color] = [Color.blue, Color.green, Color.orange],
        backgroundColor: Color = Color(
            red: 21 / 255,
            green: 24 / 255,
            blue: 30 / 255,
            opacity: 1.0
        ),
        widthFraction: CGFloat = 0.75,
        innerRadiusFraction: CGFloat = 0.60
    ) {
        self.values = values
        self.names = names
        self.formatter = formatter

        self.colors = colors
        self.backgroundColor = backgroundColor
        self.widthFraction = widthFraction
        self.innerRadiusFraction = innerRadiusFraction
    }

    // MARK: Public

    public let values: [Double]
    public let names: [String]
    public let formatter: (Double) -> String

    public var colors: [Color]
    public var backgroundColor: Color

    public var widthFraction: CGFloat
    public var innerRadiusFraction: CGFloat

    public var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    ForEach(0 ..< values.count, id: \.self) { i in
                        PieSlice(pieSliceData: slices[i])
                            .scaleEffect(activeIndex == i ? 1.03 : 1)
                            .animation(Animation.spring())
                    }
                    .frame(
                        width: widthFraction * geometry.size.width,
                        height: widthFraction * geometry.size.width
                    )
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                let radius = 0.5 * widthFraction * geometry.size
                                    .width
                                let diff = CGPoint(
                                    x: value.location.x - radius,
                                    y: radius - value.location.y
                                )
                                let dist = pow(
                                    pow(diff.x, 2.0) + pow(diff.y, 2.0),
                                    0.5
                                )
                                if dist > radius || dist < radius *
                                    innerRadiusFraction {
                                    activeIndex = -1
                                    return
                                }
                                var radians = Double(atan2(diff.x, diff.y))
                                if radians < 0 {
                                    radians = 2 * Double.pi + radians
                                }

                                for (i, slice) in slices.enumerated() {
                                    if radians < slice.endAngle.radians {
                                        activeIndex = i
                                        break
                                    }
                                }
                            }
                            .onEnded { _ in
                                activeIndex = -1
                            }
                    )
                    Circle()
                        .fill(backgroundColor)
                        .frame(
                            width: widthFraction * geometry.size
                                .width * innerRadiusFraction,
                            height: widthFraction * geometry.size
                                .width * innerRadiusFraction
                        )

                    VStack {
                        Text(
                            activeIndex == -1 ?
                                String(format: NSLocalizedString(
                                    "总计",
                                    comment: "total"
                                )) : names[activeIndex]
                        )
                        .font(.headline)
                        .foregroundColor(Color.gray)
                        Text(
                            formatter(
                                activeIndex == -1 ? values
                                    .reduce(0, +) : values[activeIndex]
                            )
                        )
                        .font(.title)
                    }
                }
                PieChartRows(
                    colors: colors,
                    names: names,
                    values: values.map { formatter($0) },
                    percents: values
                        .map {
                            String(
                                format: "%.0f%%",
                                $0 * 100 / values.reduce(0, +)
                            )
                        }
                )
            }
            .background(backgroundColor)
            .foregroundColor(Color.primary)
        }
    }

    // MARK: Internal

    var slices: [PieSliceData] {
        let sum = values.reduce(0, +)
        var endDeg: Double = 0
        var tempSlices: [PieSliceData] = []

        for (i, value) in values.enumerated() {
            let degrees: Double = value * 360 / sum
            if degrees < 18 {
                tempSlices.append(PieSliceData(
                    startAngle: Angle(degrees: endDeg),
                    endAngle: Angle(degrees: endDeg + degrees),
                    text: String(format: "%.0f%%", value * 100 / sum),
                    color: colors[i],
                    isIgnored: true
                ))
            } else {
                tempSlices.append(PieSliceData(
                    startAngle: Angle(degrees: endDeg),
                    endAngle: Angle(degrees: endDeg + degrees),
                    text: String(format: "%.0f%%", value * 100 / sum),
                    color: colors[i]
                ))
            }
            endDeg += degrees
        }
        return tempSlices
    }

    // MARK: Private

    @State
    private var activeIndex: Int = -1
}

// MARK: - PieChartRows

@available(OSX 10.15, *)
struct PieChartRows: View {
    var colors: [Color]
    var names: [String]
    var values: [String]
    var percents: [String]

    var body: some View {
        VStack {
            ForEach(values.indices, id: \.self) { i in
                HStack {
                    RoundedRectangle(cornerRadius: 5.0)
                        .fill(colors[i])
                        .frame(width: 20, height: 20)
                    Text(names[i])
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(values[i])
                        Text(percents[i])
                            .foregroundColor(Color.gray)
                    }
                }
            }
        }
    }
}

// MARK: - PieChartView_Previews

@available(OSX 10.15.0, *)
struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        PieChartView(
            values: [1300, 500, 300],
            names: ["Rent", "Transport", "Education"],
            formatter: { value in String(format: "$%.2f", value) }
        )
    }
}
