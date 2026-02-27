import SwiftUI

struct HomeView: View {
    
    @Binding var missions: [Mission]
    @Binding var activeMission: Mission?
    
    @State private var moveClouds = false
    
    var turbulenceLevel: Double {
        activeMission == nil ? 80 : 30
    }
    
    var altitudeLevel: Double {
        activeMission == nil ? 20 : 70
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
                            .background(.ultraThinMaterial)
                            .foregroundColor(.black)
                            .cornerRadius(16)
                    }
                    
                    NavigationLink {
                        TaskTrackerView()
                    } label: {
                        Text("Task Tracker")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.ultraThinMaterial)
                            .foregroundColor(.black)
                            .cornerRadius(16)
                    }
                    
                    if activeMission != nil {
                        Button("End Mission") {
                            activeMission = nil
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // FLIGHT LOG ABOVE GAUGES
                HStack(spacing: 40) {
                    NavigationLink("Flight Log") {
                        FlightLogView(missions: missions)
                    }
                    .foregroundColor(.white)
                    
                    NavigationLink("Plane Overview") {
                        PlaneOverviewView()
                    }
                    .foregroundColor(.white)
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
                                .frame(width: 40,
                                       height: CGFloat(altitudeLevel / 100) * 150)
                        }
                    }
                }
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
