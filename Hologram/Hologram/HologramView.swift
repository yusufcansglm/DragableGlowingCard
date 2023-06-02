//
//  HologramView.swift
//  Hologram
//
//  Created by Yusuf Can Sağlam on 1.06.2023.
//

import SwiftUI

struct HologramView: View {
    @State private var animationProgress: CGFloat = 0.0

    var body: some View {
        HologramShape()
            .stroke(style: StrokeStyle(lineWidth: 1, lineJoin: .round))
            .foregroundColor(.blue)
            .opacity(0.8)
            .animation(.easeInOut(duration: 0.3))
            .onTapGesture {
                withAnimation {
                    self.animationProgress = self.animationProgress == 0.0 ? 1.0 : 0.0
                }
            }
            .modifier(HologramEffect(progress: $animationProgress))
    }
}
