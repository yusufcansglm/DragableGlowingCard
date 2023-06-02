import SwiftUI

struct ContentView: View {
    @State private var cardOffset: CGSize = .zero
    @State private var isDragging: Bool = false

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            CardView()
                .frame(width: 360, height: 240)
                .overlay(
                    ZStack {
                        RoundedRectangle(cornerRadius: 30).stroke(.linearGradient(colors: [.white.opacity(0.6), .clear, .white.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        RoundedRectangle(cornerRadius: 30).stroke(.linearGradient(colors: [.white.opacity(0.4), .clear, .white.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 20)
                            .blur(radius: 30)
                        RoundedRectangle(cornerRadius: 30).stroke(.linearGradient(colors: [Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)).opacity(1), Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)).opacity(0.6), Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)).opacity(1)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 20)
                            .blur(radius: 50)
                            .opacity(isDragging ? 1 : 0)
                        RoundedRectangle(cornerRadius: 30).fill(.linearGradient(colors: [Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .blendMode(.overlay)
                    }
                )
                .offset(cardOffset)
                .rotation3DEffect(
                    Angle(degrees: cardOffset != .zero ? 15 : 0),
                    axis: (x: -cardOffset.height, y: cardOffset.width, z: 0.0)
                )
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            cardOffset = value.translation
                            isDragging = true
                        }
                        .onEnded { _ in
                            withAnimation(.spring()) {
                                cardOffset = .zero
                            }
                            isDragging = false
                        }
                )

            ParticleEmitterView(isDragging: $isDragging)
                .frame(width: 360, height: 240)
                .offset(cardOffset)
                .rotation3DEffect(
                    Angle(degrees: cardOffset != .zero ? 15 : 0),
                    axis: (x: -cardOffset.height, y: cardOffset.width, z: 0.0)
                )
                .allowsHitTesting(false) // Add this line
                .blendMode(.colorDodge)
        }
    }
}

struct CardView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Debit Card")
                .font(.headline)
                .foregroundColor(.white)
            Text("**** 0941")
                .font(.body)
                .foregroundColor(.white)
            Spacer()
            HStack {
                Text("Valid Thru 06/05")
                    .font(.caption)
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "applelogo")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }
        }
        .padding(30)
        .background(gradientBackground)
        .cornerRadius(30)
        .overlay(RoundedRectangle(cornerRadius: 30).strokeBorder(gradientOutline, lineWidth: 2))
        .shadow(color: Color(hex: "#5D11F7").opacity(0.8), radius: 120, x: 0, y: 0)
    }

    var gradientBackground: some View {
        LinearGradient(gradient: Gradient(colors: [Color(hex: "#8E5AF7"), Color(hex: "#5D11F7")]), startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    var gradientOutline: LinearGradient {
        LinearGradient(gradient: Gradient(stops: [
            Gradient.Stop(color: Color.white.opacity(0.5), location: 0),
            Gradient.Stop(color: Color.clear, location: 0.5),
            Gradient.Stop(color: Color.white.opacity(0.5), location: 1)
        ]), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

struct ParticleEmitterView: UIViewRepresentable {
    @Binding var isDragging: Bool

    // Add this array of colors for the particles
    let particleColors: [UIColor] = [
        .systemBlue, .systemPurple, .systemPink, .systemTeal
    ]

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let emitterLayer = createEmitterLayer()
        view.layer.addSublayer(emitterLayer)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        guard let emitterLayer = uiView.layer.sublayers?.compactMap({ $0 as? CAEmitterLayer }).first else { return }

        emitterLayer.emitterCells?.forEach { cell in
            cell.birthRate = isDragging ? 10 : 7
            cell.velocity = isDragging ? 100 : 50
            cell.lifetime = isDragging ? 3 : 2
            cell.scale = isDragging ? 0.1 : 0.05
        }
    }

    private func createEmitterLayer() -> CAEmitterLayer {
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterShape = .rectangle
        emitterLayer.emitterSize = CGSize(width: 360, height: 240)
        emitterLayer.emitterPosition = CGPoint(x: 180, y: 120)
        emitterLayer.renderMode = .oldestFirst
        emitterLayer.emitterCells = createEmitterCells()
        return emitterLayer
    }

    private func createEmitterCells() -> [CAEmitterCell] {
        let numberOfEmitters = 40
        return (0..<numberOfEmitters).map { index in
            let emitterCell = createEmitterCell()
            let emissionLongitude = Double(index) * (2 * Double.pi) / Double(numberOfEmitters)
            emitterCell.emissionLongitude = CGFloat(emissionLongitude)
            emitterCell.birthRate = 5
            emitterCell.velocity = 50
            emitterCell.lifetime = 1.5

            // Randomly select a color from the particleColors array
            let randomColor = particleColors.randomElement() ?? .white
            emitterCell.color = randomColor.cgColor // Set the emitterCell's color

            return emitterCell
        }
    }

    private func createEmitterCell() -> CAEmitterCell {
        let emitterCell = CAEmitterCell()

        // Custom white circle image
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 20, height: 20))
        let whiteCircle = renderer.image { context in
            UIColor.white.setFill()
            context.cgContext.fillEllipse(in: CGRect(x: 0, y: 0, width: 20, height: 20))
        }
        emitterCell.contents = whiteCircle.cgImage

        emitterCell.birthRate = 1
        emitterCell.lifetime = 1.0
        emitterCell.scale = 0.1
        emitterCell.scaleRange = 0.02
        emitterCell.scaleSpeed = -0.05
        emitterCell.velocity = 40
        emitterCell.velocityRange = 10
        emitterCell.yAcceleration = 0
        emitterCell.alphaRange = 0.5
        emitterCell.alphaSpeed = -0.5
        return emitterCell
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
