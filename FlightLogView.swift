import SwiftUI

struct FlightLogView: View {
    
    var missions: [Mission]
    
    var body: some View {
        VStack {
            Text("Focus Log")
                .font(.largeTitle)
                .padding()
            
            List(missions) { mission in
                HStack {
                    Text(mission.name)
                    Spacer()
                    Text("\(mission.duration) min")
                }
            }
            
            NavigationLink("Next →") {
                FlightLogDetailView()
            }
            .padding()
        }
    }
}
