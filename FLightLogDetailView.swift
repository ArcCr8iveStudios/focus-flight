import SwiftUI

struct FlightLogDetailView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.gray.opacity(0.65).ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Focus Log")
                    .font(.system(size: 58, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(Color.white.opacity(0.55))
                    .overlay {
                        VStack(spacing: 0) {
                            HStack(spacing: 0) {
                                header("Turbulence")
                                header("Altitude")
                            }
                            Divider().background(Color.blue.opacity(0.4))

                            Spacer()

                            HStack {
                                Button("← Back") {
                                    dismiss()
                                }
                                .font(.system(size: 38, design: .rounded))
                                .foregroundColor(.black.opacity(0.8))

                                Spacer()
                            }
                            .padding()
                        }
                        .overlay {
                            Rectangle().fill(Color.blue.opacity(0.35)).frame(width: 3)
                        }
                    }
            }
            .padding(24)
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private func header(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 38, weight: .medium, design: .rounded))
            .foregroundColor(.red.opacity(0.75))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
    }
}
