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
            
            Text("Select Duration")
                .font(.headline)
            
            Picker("Duration", selection: $duration) {
                ForEach(5...180, id: \.self) { minute in
                    if minute % 5 == 0 {
                        Text("\(minute) min").tag(minute)
                    }
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 150)
            
            Button("Start Mission") {
                guard !missionName.isEmpty else { return }
                
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
            
            Spacer()
        }
        .navigationTitle("New Mission")
    }
}
