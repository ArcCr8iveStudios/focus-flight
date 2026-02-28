import SwiftUI

struct FlightLogDetailView: View {
    @Environment(\.dismiss) private var dismiss

    private let turbulenceHistory = [
        "Session 1   +3",
        "Session 2   -1",
        "Session 3   +2",
        "Session 4   -2"
    ]

    private let altitudeHistory = [
        "Session 1   +5",
        "Session 2   +2",
        "Session 3   -1",
        "Session 4   +4"
    ]

    var body: some View {
        ZStack {
            Color.gray.opacity(0.65).ignoresSafeArea()

            VStack(spacing: 24) {
                HStack {
                    Button("←") { dismiss() }
                        .font(.system(size: 42, weight: .medium, design: .rounded))
                        .foregroundColor(.black.opacity(0.85))
                    Spacer()
                }

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

                            HStack(alignment: .top, spacing: 0) {
                                historyColumn(entries: turbulenceHistory)
                                historyColumn(entries: altitudeHistory)
                            }

                            Spacer(minLength: 8)
                            Spacer()

                            HStack {
                                Button("← Back") {
                                    dismiss()
                                }
                                .font(.system(size: 36, design: .rounded))
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
            .foregroundColor(.orange)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
    }

    private func historyColumn(entries: [String]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(entries, id: \.self) { entry in
                Text(entry)
                    .font(.system(size: 28, design: .rounded))
                    .foregroundColor(.blue)
            }
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
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
