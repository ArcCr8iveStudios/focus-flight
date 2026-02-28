import SwiftUI

struct MissionSetupView: View {
    @Binding var missions: [Mission]
    @Binding var activeMission: Mission?

    @State private var missionName: String = ""
    @State private var hours: Int = 0
    @State private var minutes: Int = 25
    @State private var showMissionBrief: Bool = false

    @FocusState private var isMissionNameFocused: Bool
    @Environment(\.dismiss) private var dismiss

    private var totalDurationMinutes: Int {
        max((hours * 60) + minutes, 1)
    }

    private var durationDisplayText: String {
        "\(hours)h \(minutes)m"
    }

    var body: some View {
        ZStack {
            Color.gray.opacity(0.65)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                HStack {
                    Button("←") {
                        dismiss()
                    }
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
        .onAppear {
            isMissionNameFocused = true
        }
    }

    private var missionInputView: some View {
        VStack(spacing: 28) {
            VStack(spacing: 14) {
                Text("Mission Name")
                    .font(.system(size: 44, weight: .medium, design: .rounded))

                TextField("Type mission name", text: $missionName)
                    .font(.system(size: 30, weight: .regular, design: .rounded))
                    .textFieldStyle(.plain)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled(true)
                    .submitLabel(.done)
                    .focused($isMissionNameFocused)
                    .padding(.vertical, 14)
                    .padding(.horizontal, 20)
                    .background(Color.white.opacity(0.9))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .frame(maxWidth: .infinity)
            }

            VStack(spacing: 10) {
                Text("Mission Duration")
                    .font(.system(size: 36, weight: .medium, design: .rounded))

                HStack(spacing: 0) {
                    Picker("Hours", selection: $hours) {
                        ForEach(0...12, id: \.self) { hour in
                            Text("\(hour) h").tag(hour)
                        }
                    }
                    .pickerStyle(.wheel)

                    Picker("Minutes", selection: $minutes) {
                        ForEach(0...59, id: \.self) { minute in
                            Text("\(minute) m").tag(minute)
                        }
                    }
                    .pickerStyle(.wheel)
                }
                .frame(height: 180)
                .clipped()
            }

            Spacer()

            Button("Start Mission") {
                let trimmed = missionName.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmed.isEmpty else {
                    isMissionNameFocused = true
                    return
                }

                let newMission = Mission(name: trimmed, duration: totalDurationMinutes, date: Date())
                missions.append(newMission)
                activeMission = newMission
                showMissionBrief = true
            }
            .font(.system(size: 44, weight: .medium, design: .rounded))
            .padding(.vertical, 18)
            .padding(.horizontal, 44)
            .background(Color.red.opacity(0.72))
            .foregroundColor(.black.opacity(0.85))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
    }

    private var missionSummaryView: some View {
        VStack(spacing: 20) {
            Text(missionName)
                .font(.system(size: 56, weight: .medium, design: .rounded))

            Text("Session Time")
                .font(.system(size: 44, weight: .medium, design: .rounded))

            Text(durationDisplayText)
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
}
