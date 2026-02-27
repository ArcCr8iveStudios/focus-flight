import SwiftUI

struct MissionSetupView: View {
    
    @Binding var missions: [Mission]
    @Binding var activeMission: Mission?
    
    @State private var missionName = ""
    @State private var duration = 25
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            
            TextField("Mission Name", text: $missionName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Stepper("Duration: \(duration) min", value: $duration, in: 5...180, step: 5)
                .padding()
            
            Button("Start") {
                let newMission = Mission(
                    name: missionName,
                    duration: duration,
                    date: Date()
                )
                
                missions.append(newMission)
                activeMission = newMission
                
                dismiss()
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.black)
            .cornerRadius(12)
        }
        .navigationTitle("New Mission")
    }
}

