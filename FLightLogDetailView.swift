import SwiftUI

struct FlightLogDetailView: View {
    let missions: [Mission]

    @Environment(\.dismiss) private var dismiss

    private var completedMissions: [Mission] {
        missions.filter { $0.isCompleted }
    }

    private var turbulenceEntries: [TurbulenceEntry] {
        completedMissions.map { mission in
            TurbulenceEntry(
                label: mission.name,
                delta: mission.turbulenceDelta
            )
        }
    }

    private var altitudeHistory: [String] {
        completedMissions.map { mission in
            let sign = mission.duration >= 60 ? "+" : "-"
            let value = max(1, mission.duration / 20)
            return "\(mission.name)  \(sign)\(value)"
        }
    }

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
                                turbulenceColumn(entries: turbulenceEntries)
                                altitudeColumn(entries: altitudeHistory)
                            }

                            Spacer(minLength: 8)

                            HStack {
                                Button("← Back") {
                                    dismiss()
                                }
                                .font(.system(size: 36, design: .rounded))
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

    private func turbulenceColumn(entries: [TurbulenceEntry]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            if entries.isEmpty {
                Text("No mission history")
                    .font(.system(size: 24, design: .rounded))
                    .foregroundColor(.gray)
            } else {
                ForEach(entries) { entry in
                    Text(entry.display)
                        .font(.system(size: 24, design: .rounded))
                        .foregroundColor(entry.delta >= 0 ? .green : .red)
                }
            }

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
    }

    private func altitudeColumn(entries: [String]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            if entries.isEmpty {
                Text("No mission history")
                    .font(.system(size: 24, design: .rounded))
                    .foregroundColor(.gray)
            } else {
                ForEach(entries, id: \.self) { entry in
                    Text(entry)
                        .font(.system(size: 24, design: .rounded))
                        .foregroundColor(.blue)
                }
            }

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
    }
}

private struct TurbulenceEntry: Identifiable {
    let id = UUID()
    let label: String
    let delta: Int

    var display: String {
        let sign = delta >= 0 ? "+" : ""
        return "\(label)  \(sign)\(delta)"
    }
}
