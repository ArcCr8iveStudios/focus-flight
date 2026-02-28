import SwiftUI

struct RootView: View {
    @State private var missions: [Mission] = []
    @State private var activeMission: Mission? = nil

    var body: some View {
        NavigationStack {
            HomeView(
                missions: $missions,
                activeMission: $activeMission
            )
        }
    }
}
