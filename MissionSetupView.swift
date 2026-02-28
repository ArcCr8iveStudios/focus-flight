import SwiftUI

struct MissionSetupView: View {
    @Binding var missions: [Mission]
    @Binding var activeMission: Mission?

    @State private var missionName = ""
    @State private var duration = 25
    @State private var startTime = Date()
    @State private var showMissionBrief = false

    @Environment(\.dismiss) private var dismiss

    private var endTime: Date {
        startTime.addingTimeInterval(Double(duration) * 60)
    }

    var body: some View {
        ZStack {
            Color.gray.opacity(0.65).ignoresSafeArea()

            VStack(spacing: 24) {
                HStack {
                    Button("←") { dismiss() }
                        .font(.system(size: 44, weight: .medium, design: .rounded))
                        .foregroundColor(.black.opacity(0.8))
                    Spacer()
                }

                Text("Mission Breif")
                    .font(.system(size: 52, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if showMissionBrief {
                    missionSummaryView
                } else {
                    missionInputView
                }

                Spacer()
            }
            .padding(24)
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var missionInputView: some View {
        VStack(spacing: 30) {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color.white.opacity(0.55))
                .overlay {
                    VStack(spacing: 18) {
                        timeRow(label: "Start\nTime", date: startTime)
                        timeRow(label: "End\nTime", date: endTime)
                    }
                    .padding()
                }
                .frame(height: 220)

            VStack(spacing: 14) {
                Text("Mission Name")
                    .font(.system(size: 44, weight: .medium, design: .rounded))

                TextField("Value", text: $missionName)
                    .font(.system(size: 28, weight: .regular, design: .rounded))
                    .textFieldStyle(.plain)
                    .padding(.vertical, 14)
                    .padding(.horizontal, 20)
                    .background(Color.white.opacity(0.9))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .frame(maxWidth: 240)
            }

            Stepper("Duration: \(duration) min", value: $duration, in: 5...180, step: 5)
                .font(.system(size: 26, design: .rounded))
                .padding(.horizontal)

            Spacer()

            Button {
                guard !missionName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

                let newMission = Mission(name: missionName, duration: duration, date: startTime)
                missions.append(newMission)
                activeMission = newMission
                showMissionBrief = true
            } label: {
                Text("Start Mission")
                    .font(.system(size: 44, weight: .medium, design: .rounded))
                    .padding(.vertical, 18)
                    .padding(.horizontal, 44)
                    .background(Color.red.opacity(0.72))
                    .foregroundColor(.black.opacity(0.85))
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            }
            .buttonStyle(.plain)
        }
    }

    private var missionSummaryView: some View {
        VStack(spacing: 20) {
            Text(missionName)
                .font(.system(size: 56, weight: .medium, design: .rounded))

            Text("Session Time")
                .font(.system(size: 44, weight: .medium, design: .rounded))

            Text("\(duration) min")
                .font(.system(size: 30, weight: .medium, design: .rounded))
                .padding(.horizontal, 24)
                .padding(.vertical, 10)
                .background(Color.blue.opacity(0.35))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

            Text("Aircraft Upgrade")
                .font(.system(size: 54, weight: .medium, design: .rounded))
                .foregroundColor(.red.opacity(0.65))

            HStack(spacing: 40) {
                Image(systemName: "airplane")
                Text("→")
                Image(systemName: "airplane")
            }
            .font(.system(size: 62))

            ProgressView(value: 0.55)
                .tint(.blue)
                .scaleEffect(x: 1, y: 2, anchor: .center)
                .padding(.horizontal)

            Spacer()

            HStack(spacing: 16) {
                Button("← Back") {
                    showMissionBrief = false
                }
                .font(.system(size: 34, design: .rounded))

                Spacer()

                Button("Start Mission") {
                    dismiss()
                }
                .font(.system(size: 44, weight: .medium, design: .rounded))
                .padding(.vertical, 18)
                .padding(.horizontal, 42)
                .background(Color.red.opacity(0.72))
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            }
            .foregroundColor(.black.opacity(0.85))
        }
    }

    private func timeRow(label: String, date: Date) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 40, weight: .medium, design: .rounded))
                .multilineTextAlignment(.leading)

            Spacer()

            Text(date.formatted(date: .abbreviated, time: .omitted))
                .font(.system(size: 30, design: .rounded))
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color.gray.opacity(0.22))
                .clipShape(Capsule())

            Text(date.formatted(date: .omitted, time: .shortened))
                .font(.system(size: 30, design: .rounded))
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color.gray.opacity(0.22))
                .clipShape(Capsule())
        }
    }
}
