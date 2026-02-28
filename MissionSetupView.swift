import SwiftUI

struct MissionSetupView: View {
    @Binding var missions: [Mission]
    @Binding var activeMission: Mission?

    @State private var missionName = ""
    @State private var duration = 25
    @State private var showMissionBrief = false

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        ZStack {
            Color.gray.opacity(0.65).ignoresSafeArea()

            VStack(spacing: 24) {
                HStack {
                    Button("←") { presentationMode.wrappedValue.dismiss() }
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
        VStack(spacing: 28) {
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

            VStack(spacing: 10) {
                Text("Mission Duration")
                    .font(.system(size: 36, weight: .medium, design: .rounded))

                Picker("Mission Duration", selection: $duration) {
                    ForEach(Array(stride(from: 5, through: 180, by: 5)), id: \.self) { minute in
                        Text("\(minute) min")
                            .font(.system(size: 28, design: .rounded))
                            .tag(minute)
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 170)
                .clipped()
            }

            Spacer()

            Button {
                guard !missionName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

                let newMission = Mission(name: missionName, duration: duration, date: Date())
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
@@ -129,55 +125,26 @@ struct MissionSetupView: View {
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
                    presentationMode.wrappedValue.dismiss()
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
