import SwiftUI

struct RootView: View {
    @State private var missions: [Mission] = []
    @State private var activeMission: Mission? = nil
    @State private var tasks: [TaskItem] = []

    @State private var currentPlaneIndex: Int = 0
    @State private var levelProgressMinutes: Int = 0
    @State private var turbulencePoints: Int = 0

    var body: some View {
        NavigationStack {
            HomeView(
                missions: $missions,
                activeMission: $activeMission,
                tasks: $tasks,
                currentPlaneIndex: $currentPlaneIndex,
                levelProgressMinutes: $levelProgressMinutes,
                turbulencePoints: $turbulencePoints
            )
        }
    }
}
