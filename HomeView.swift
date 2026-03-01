import SwiftUI
import AudioToolbox

struct HomeView: View {
    @Binding var missions: [Mission]
    @Binding var activeMission: Mission?
    @Binding var tasks: [TaskItem]

    @Binding var currentPlaneIndex: Int
    @Binding var levelProgressMinutes: Int
    @Binding var turbulencePoints: Int

    @State private var showAlarmPopup = false
    @State private var alarmTimer: Timer?
    @State private var alarmEndDate: Date?
    @State private var missionDueTimer: Timer?
    @State private var alarmedMissionID: Mission.ID?

    var completedMissions: Int {
        missions.filter { $0.isCompleted }.count
    }

    var currentPlane: PlaneTier {
        PlaneCatalog.tier(at: currentPlaneIndex)
    }

    var nextPlane: PlaneTier? {
        PlaneCatalog.tier(at: currentPlaneIndex + 1)
    }

    var turbulenceLevel: Double {
        Double(turbulencePoints)
    }

    var altitudeLevel: Double {
        let needed = PlaneCatalog.minutesNeededToReachNextLevel(from: currentPlaneIndex)
        guard needed > 0 else { return 100 }
        return min(Double(levelProgressMinutes) / Double(needed) * 100, 100)
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
        .onAppear { refreshMissionDueTimer() }
        .onDisappear {
            stopAlarm()
            stopMissionDueTimer()
        }
        .onChange(of: activeMission?.id) { _ in
            if activeMission == nil { alarmedMissionID = nil }
            refreshMissionDueTimer()
        }
    }

    private var mainContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Focus Flight")
                .font(.system(size: 52, weight: .bold, design: .rounded))
                .minimumScaleFactor(0.6)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 8)

            HStack(alignment: .top) {
                cloud(scale: 0.8)
                Spacer()
                cloud(scale: 1.2)
            }

            HStack(spacing: 18) {
                navButton("Start Mission", color: .red.opacity(0.75)) {
                    MissionSetupView(
                        missions: $missions,
                        activeMission: $activeMission,
                        currentPlaneIndex: $currentPlaneIndex
                    )
                }

                navButton("Task Tracker", color: .orange.opacity(0.8)) {
                    TaskTrackerView(tasks: $tasks)
                }
            }

            navButton("Flight Log", color: .green.opacity(0.75)) {
                FlightLogView(missions: missions, tasks: tasks)
            }
            .frame(maxWidth: 230)

            NavigationLink {
                PlaneOverviewView(
                    missions: missions,
                    currentPlaneIndex: currentPlaneIndex,
                    levelProgressMinutes: levelProgressMinutes
                )
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
                            .trim(from: 0.05, to: 0.95)
                            .stroke(Color.white, lineWidth: 14)
                            .rotationEffect(.degrees(90))
                            .frame(width: 138, height: 138)

                        Circle()
                            .trim(from: 0, to: min(max(turbulenceLevel / 100, 0), 1) * 0.9)
                            .stroke(Color.red,
                                    style: .init(lineWidth: 14, lineCap: .round))
                            .rotationEffect(.degrees(180))
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
 private var tutorialSteps: [(title: String, message: String)] {
        [
            ("Welcome to Focus Flight", "This quick tutorial shows where to start your focus sessions and track progress."),
            ("Start Mission", "Tap Start Mission to create a Mission Brief, set your timer, and launch your focus session."),
            ("Task Tracker", "Use Task Tracker to add and complete tasks. Completed tasks appear in your Flight Log."),
            ("Flight Log", "Tap the centered Flight Log button to review mission history and completed tasks anytime.")
        ]
    }

    private var tutorialSheet: some View {
        let step = tutorialSteps[tutorialStep]

        return ZStack {
            Color(red: 0.58, green: 0.73, blue: 0.94)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Tutorial")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                Text("Step \(tutorialStep + 1) of \(tutorialSteps.count)")
                    .font(.system(size: 22, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))

                VStack(spacing: 16) {
                    Text(step.title)
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black.opacity(0.85))

                    Text(step.message)
                        .font(.system(size: 24, weight: .regular, design: .rounded))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black.opacity(0.8))
                }
                .padding(24)
                .frame(maxWidth: .infinity)
                .background(Color.white.opacity(0.85))
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

                HStack(spacing: 14) {
                    if tutorialStep > 0 {
                        Button("Back") {
                            tutorialStep -= 1
                        }
                        .font(.system(size: 26, weight: .medium, design: .rounded))
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)
                        .background(Color.white.opacity(0.8))
                        .foregroundColor(.black.opacity(0.85))
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }

                    Spacer()

                    Button(tutorialStep == tutorialSteps.count - 1 ? "Done" : "Next") {
                        if tutorialStep == tutorialSteps.count - 1 {
                            hasSeenHomeTutorial = true
                            showTutorial = false
                        } else {
                            tutorialStep += 1
                        }
                    }
                    .font(.system(size: 26, weight: .medium, design: .rounded))
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
                    .background(Color.green.opacity(0.8))
                    .foregroundColor(.black.opacity(0.85))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
            }
            .padding(24)
        }
        .presentationDetents([.medium, .large])
        .interactiveDismissDisabled()
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

    private func cloud(scale: CGFloat) -> some View {
        ZStack {
            Circle().fill(Color.white.opacity(0.92)).frame(width: 78 * scale)
            Circle().fill(Color.white.opacity(0.92)).frame(width: 88 * scale).offset(x: 42 * scale, y: 5 * scale)
            Circle().fill(Color.white.opacity(0.92)).frame(width: 70 * scale).offset(x: -40 * scale, y: 10 * scale)
            RoundedRectangle(cornerRadius: 30 * scale).fill(Color.white.opacity(0.92)).frame(width: 185 * scale, height: 66 * scale).offset(y: 20 * scale)
        }
        .frame(width: 210 * scale, height: 100 * scale)
    }

    private func endMission() {
        guard let active = activeMission,
              let index = missions.firstIndex(where: { $0.id == active.id }) else { return }

        let missionImpact = max(1, currentPlaneIndex + 1)
        let distractions = Int.random(in: 1...missionImpact)
        let turbulenceIncrease = distractions * 10

        let elapsedSeconds = max(0, Date().timeIntervalSince(active.date))
        let elapsedMinutes = min(active.duration, Int(elapsedSeconds / 60.0))

        turbulencePoints = min(100, turbulencePoints + turbulenceIncrease)
        missions[index].turbulenceDelta = -turbulenceIncrease
        missions[index].duration = elapsedMinutes

        if turbulencePoints >= 100 {
            currentPlaneIndex = max(0, currentPlaneIndex - 1)
            levelProgressMinutes = 0
            turbulencePoints = 0
        } else {
            applyMinutesProgress(elapsedMinutes)
        }

        missions[index].isActive = false
        missions[index].isCompleted = true
        activeMission = nil

        stopMissionDueTimer()
    }


    private func applyMinutesProgress(_ earnedMinutes: Int) {
        var carry = max(0, earnedMinutes)

        while carry > 0 {
            let needed = PlaneCatalog.minutesNeededToReachNextLevel(from: currentPlaneIndex)
            let remainingToLevel = max(needed - levelProgressMinutes, 0)

            if carry >= remainingToLevel, currentPlaneIndex < PlaneCatalog.tiers.count - 1 {
                carry -= remainingToLevel
                currentPlaneIndex += 1
                levelProgressMinutes = 0
                turbulencePoints = 0
            } else {
                levelProgressMinutes += carry
                carry = 0
            }
        }
    }

    private func refreshMissionDueTimer() {
        stopMissionDueTimer()
        guard let activeMission else { return }

        missionDueTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            let endDate = activeMission.date.addingTimeInterval(TimeInterval(activeMission.duration * 60))
            if Date() >= endDate, alarmedMissionID != activeMission.id {
                alarmedMissionID = activeMission.id
                startAlarm(duration: 10)
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
