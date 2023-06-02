//
//  ContentView.swift
//  Hologram
//
//  Created by Yusuf Can Sağlam on 1.06.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        SunflowerView()
            .background(Color.black)
            .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct SunflowerShape: Shape {
    let seedCount: Int

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let angleIncrement = 2 * Double.pi * (1.0 - (1.0 / Constants.goldenRatio))
        let maxRadius = min(rect.width, rect.height) * 0.5
        let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)

        for i in 0..<seedCount {
            let radius = sqrt(Double(i)) * maxRadius / sqrt(Double(seedCount))
            let angle = Double(i) * angleIncrement
            let x = center.x + CGFloat(radius * cos(angle))
            let y = center.y + CGFloat(radius * sin(angle))
            let circleSize = CGFloat(1.0 - (radius / maxRadius)) * 8
            let circle = Path(ellipseIn: CGRect(x: x - circleSize * 0.5, y: y - circleSize * 0.5, width: circleSize, height: circleSize))
            path.addPath(circle)
        }

        return path
    }

    struct Constants {
        static let goldenRatio: Double = 1.61803398875
    }
}

struct SunflowerView: View {
    @State private var showGalaxy = false
    private let seedCount = 200

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<seedCount) { index in
                    Circle()
                        .fill(randomColor())
                        .frame(width: circleSize(index: index, rect: geometry.frame(in: .local)), height: circleSize(index: index, rect: geometry.frame(in: .local)))
                        .position(circlePosition(index: index, rect: geometry.frame(in: .local)))
                        .transition(.opacity)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .onTapGesture {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0)) {
                    self.showGalaxy.toggle()
                }
            }
        }
        .drawingGroup()
    }

    private func randomColor() -> Color {
        let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple]
        return colors.randomElement() ?? .black
    }

    private func circlePosition(index: Int, rect: CGRect) -> CGPoint {
        if showGalaxy {
            return galaxyPosition(index: index, rect: rect)
        } else {
            return sunflowerPosition(index: index, rect: rect)
        }
    }

    private func sunflowerPosition(index: Int, rect: CGRect) -> CGPoint {
        let angleIncrement = 2 * Double.pi * (1.0 - (1.0 / Constants.goldenRatio))
        let maxRadius = min(rect.width, rect.height) * 0.8 // Increased the factor
        let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)

        let radius = sqrt(Double(index)) * maxRadius / sqrt(Double(seedCount))
        let angle = Double(index) * angleIncrement
        let x = center.x + CGFloat(radius * cos(angle))
        let y = center.y + CGFloat(radius * sin(angle))

        return CGPoint(x: x, y: y)
    }

    private func galaxyPosition(index: Int, rect: CGRect) -> CGPoint {
        let angleIncrement = (2 * Double.pi / Double(seedCount)) * 4.0 // Increased the number of turns by multiplying by 4
        let maxRadius = min(rect.width, rect.height) * 0.8
        let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
        let radius = pow(Double(index) / Double(seedCount), 2.0) * maxRadius
        let angle = Double(index) * angleIncrement
        let x = center.x + CGFloat(radius * cos(angle))
        let y = center.y + CGFloat(radius * sin(angle))

        return CGPoint(x: x, y: y)
    }

    private func circleSize(index: Int, rect: CGRect) -> CGFloat {
        let maxRadius = min(rect.width, rect.height) * 0.5
        let radius = sqrt(Double(index)) * maxRadius / sqrt(Double(seedCount))
        return CGFloat(1.0 - (radius / maxRadius)) * 8 * 3
    }

    struct Constants {
        static let goldenRatio: Double = 1.61803398875
    }
}
