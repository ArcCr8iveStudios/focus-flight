import SwiftUI
import AudioToolbox

struct HomeView: View {
    @Binding var missions: [Mission]
    @Binding var activeMission: Mission?

    @State private var showAlarmPopup = false
    @State private var alarmTimer: Timer?
    @State private var alarmEndDate: Date?
    @State private var missionDueTimer: Timer?
    @State private var alarmedMissionID: Mission.ID?

    var completedMissions: Int {
        missions.filter { $0.isCompleted }.count
    }

    var completedMinutes: Int {
        missions.filter { $0.isCompleted }.reduce(0) { $0 + $1.duration }
    }

    var currentLevel: Int {
        PlaneCatalog.level(forTotalMinutes: completedMinutes)
    }

    var turbulenceLevel: Double {
        let baseline: Double = activeMission == nil ? 50 : 35
        let sum = missions.filter(\.isCompleted).reduce(0) { $0 + $1.turbulenceDelta }
        let scaled = baseline + Double(sum)
        return min(max(scaled, 0), 100)
    }

    var altitudeLevel: Double {
        min(Double(completedMissions) * 14, 100)
    }

    var currentPlane: PlaneTier {
        PlaneCatalog.currentPlane(totalMinutes: completedMinutes)
    }

    var body: some View {
        ZStack {
            Color(red: 0.58, green: 0.73, blue: 0.94)
                .ignoresSafeArea()

            mainContent

            if showAlarmPopup {
                alarmOverlay
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            refreshMissionDueTimer()
        }
        .onDisappear {
            stopAlarm()
            stopMissionDueTimer()
        }
        .onChange(of: activeMission?.id) { _ in
            if activeMission == nil {
                alarmedMissionID = nil
            }
            refreshMissionDueTimer()
        }
    }

    private var mainContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 14) {
                Image(systemName: "line.3.horizontal")
                    .font(.title3)
                    .foregroundColor(.black.opacity(0.75))

                Text("Focus Flight")
                    .font(.system(size: 52, weight: .bold, design: .rounded))
                    .minimumScaleFactor(0.6)
                    .foregroundColor(.white)
            }
            .padding(.top, 8)

            cloud
                .frame(maxWidth: .infinity, alignment: .trailing)

            HStack(spacing: 18) {
                navButton("Start Mission", color: .red.opacity(0.75)) {
                    MissionSetupView(missions: $missions, activeMission: $activeMission)
                }

                navButton("Task Tracker", color: .orange.opacity(0.8)) {
                    TaskTrackerView()
                }
            }

            navButton("Flight Log", color: .green.opacity(0.75)) {
                FlightLogView(missions: missions)
            }
            .frame(maxWidth: 230)

            NavigationLink {
                PlaneOverviewView(missions: missions)
            } label: {
                VStack(spacing: 8) {
                    Image(currentPlane.assetName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 105)

                    Text(currentPlane.name)
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                }
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(PlainButtonStyle())

            HStack(alignment: .bottom, spacing: 40) {
                VStack(spacing: 10) {
                    Text("Turbulence")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    ZStack {
                        Circle()
                            .trim(from: 0.15, to: 0.95)
                            .stroke(Color.white, lineWidth: 14)
                            .frame(width: 138, height: 138)

                        Circle()
                            .trim(from: 0, to: turbulenceLevel / 100)
                            .stroke(turbulenceLevel >= 50 ? Color.green : Color.red,
                                    style: .init(lineWidth: 14, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                            .frame(width: 138, height: 138)
                    }
                }

                VStack(spacing: 10) {
                    Text("Altitude")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    ZStack(alignment: .bottom) {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.green.opacity(0.7), lineWidth: 4)
                            .frame(width: 38, height: 190)

                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.green)
                            .frame(width: 30, height: CGFloat(altitudeLevel / 100) * 186)
                    }
                }
            }

            if activeMission != nil {
                Button {
                    endMission()
                } label: {
                    Text("End Mission")
                        .font(.system(size: 36, weight: .medium, design: .rounded))
                        .padding(.vertical, 14)
                        .frame(maxWidth: .infinity)
                        .background(Color.black.opacity(0.75))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                }
                .buttonStyle(PlainButtonStyle())
            }

            Spacer(minLength: 0)
        }
        .padding(24)
    }

    private var alarmOverlay: some View {
        ZStack {
            Color.black.opacity(0.35)
                .ignoresSafeArea()

            VStack(spacing: 14) {
                Text("Mission Complete")
                    .font(.title2.bold())

                Text("Alarm is ringing")
                    .font(.body)

                Button("Turn Off") {
                    stopAlarm()
                }
                .buttonStyle(BorderedProminentButtonStyle())
            }
            .padding(20)
            .frame(maxWidth: 280)
            .background(Color.white.opacity(0.92))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }

    private func navButton<Destination: View>(_ title: String, color: Color, destination: @escaping () -> Destination) -> some View {
        NavigationLink(destination: destination()) {
            Text(title)
                .font(.system(size: 42, weight: .medium, design: .rounded))
                .minimumScaleFactor(0.5)
                .padding(.vertical, 16)
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity)
                .background(color)
                .foregroundColor(.black.opacity(0.85))
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var cloud: some View {
        ZStack {
            Circle().fill(Color.white.opacity(0.92)).frame(width: 78)
            Circle().fill(Color.white.opacity(0.92)).frame(width: 88).offset(x: 42, y: 5)
            Circle().fill(Color.white.opacity(0.92)).frame(width: 70).offset(x: -40, y: 10)
            RoundedRectangle(cornerRadius: 30).fill(Color.white.opacity(0.92)).frame(width: 185, height: 66).offset(y: 20)
        }
        .frame(width: 210, height: 100)
    }

    private func endMission() {
        guard let active = activeMission,
              let index = missions.firstIndex(where: { $0.id == active.id }) else { return }

        let magnitude = max(1, 1 + (currentLevel / 2))
        let delta = Int.random(in: -magnitude...magnitude)

        missions[index].isActive = false
        missions[index].isCompleted = true
        missions[index].turbulenceDelta = delta
        activeMission = nil

        stopMissionDueTimer()
    }

    private func refreshMissionDueTimer() {
        stopMissionDueTimer()

        guard let activeMission else { return }

        missionDueTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            let endDate = activeMission.date.addingTimeInterval(TimeInterval(activeMission.duration * 60))
            if Date() >= endDate, alarmedMissionID != activeMission.id {
                alarmedMissionID = activeMission.id
                startAlarm(duration: 3)
            }
        }
    }

    private func stopMissionDueTimer() {
        missionDueTimer?.invalidate()
        missionDueTimer = nil
    }

    private func startAlarm(duration: TimeInterval) {
        stopAlarm()
        showAlarmPopup = true

        alarmEndDate = Date().addingTimeInterval(duration)
        AudioServicesPlaySystemSound(1005)

        alarmTimer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { timer in
            guard let alarmEndDate,
                  Date() < alarmEndDate else {
                timer.invalidate()
                stopAlarm()
                return
            }

            AudioServicesPlaySystemSound(1005)
        }
    }

    private func stopAlarm() {
        alarmTimer?.invalidate()
        alarmTimer = nil
        alarmEndDate = nil
        showAlarmPopup = false
    }
}
