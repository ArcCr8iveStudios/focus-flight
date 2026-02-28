import SwiftUI

struct HomeView: View {
    
    @Binding var missions: [Mission]
    @Binding var activeMission: Mission?
    
    var completedMissions: Int {
        missions.filter { $0.isCompleted }.count
    }
    
    var turbulenceLevel: Double {
        activeMission == nil ? 80 : 30
    }
    
    var altitudeLevel: Double {
        min(Double(completedMissions) * 10, 100)
    }
    
    var body: some View {
        ZStack {
            
            LinearGradient(
                colors: [Color.blue.opacity(0.9), Color.blue.opacity(0.6)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                
                Spacer()
                
                Text("Focus Flight")
                    .font(.system(size: 36, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                
                Spacer()
                
                VStack(spacing: 20) {
                    
                    NavigationLink {
                        MissionSetupView(
                            missions: $missions,
                            activeMission: $activeMission
                        )
                    } label: {
                        Text("Start Mission")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(16)
                    }
                    
                    NavigationLink {
                        TaskTrackerView()
                    } label: {
                        Text("Task Tracker")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(16)
                    }
                    
                    if activeMission != nil {
                        Button("End Mission") {
                            endMission()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                HStack(spacing: 40) {
                    NavigationLink("Flight Log") {
                        FlightLogView(missions: missions)
                    }
                    .foregroundColor(.cyan)
                    
                    NavigationLink("Plane Overview") {
                        PlaneOverviewView()
                    }
                    .foregroundColor(.green)
                }
                
                Spacer()
                
                HStack(spacing: 60) {
                    
                    VStack {
                        Text("Turbulence")
                            .foregroundColor(.white)
                        
                        ZStack {
                            Circle()
                                .stroke(Color.white.opacity(0.3), lineWidth: 14)
                                .frame(width: 140)
                            
                            Circle()
                                .trim(from: 0, to: turbulenceLevel / 100)
                                .stroke(Color.red,
                                        style: StrokeStyle(lineWidth: 14, lineCap: .round))
                                .rotationEffect(.degrees(-90))
                                .frame(width: 140)
                        }
                    }
                    
                    VStack {
                        Text("Altitude")
                            .foregroundColor(.white)
                        
                        ZStack(alignment: .bottom) {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.4), lineWidth: 4)
                                .frame(width: 40, height: 150)
                            
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.green)
                                .frame(
                                    width: 40,
                                    height: CGFloat(altitudeLevel / 100) * 150
                                )
                        }
                    }
                }
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func endMission() {
        guard let active = activeMission else { return }
        
        if let index = missions.firstIndex(where: { $0.id == active.id }) {
            missions[index].isActive = false
            missions[index].isCompleted = true
        }
        
        activeMission = nil
    }
}
