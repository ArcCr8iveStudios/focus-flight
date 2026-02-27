import SwiftUI

struct FlightLogDetailView: View {
    
    var body: some View {
        VStack {
            Text("Turbulence     Altitude")
                .font(.headline)
                .padding()
            
            Spacer()
            
            NavigationLink("← Back") {
                EmptyView()
            }
            
            Spacer()
        }
    }
}
