import SwiftUI

struct PlaneOverviewView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.gray.opacity(0.65).ignoresSafeArea()

            VStack(spacing: 20) {
                HStack {
                    Button("←") { dismiss() }
                        .font(.system(size: 42, weight: .medium, design: .rounded))
                        .foregroundColor(.black.opacity(0.85))
                    Spacer()
                }

                Text("Aircraft Upgrade")
                    .font(.system(size: 54, weight: .medium, design: .rounded))
                    .foregroundColor(.red.opacity(0.65))

                Text("Cessna 172")
                    .font(.system(size: 58, weight: .medium, design: .rounded))

                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(Color.blue.opacity(0.45))
                    .overlay {
                        VStack(spacing: 14) {
                            Image(systemName: "airplane")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 220)
                            Text("Specs")
                                .font(.system(size: 52, weight: .bold, design: .rounded))
                            Text("hp")
                            Text("wingspan")
                            Text("weight")
                        }
                        .font(.system(size: 32, design: .rounded))
                        .foregroundColor(.black.opacity(0.85))
                    }
                    .frame(height: 430)
            }
        }
    }
}
