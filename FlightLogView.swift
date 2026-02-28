import SwiftUI

struct FlightLogView: View {
    var missions: [Mission]

    var body: some View {
        ZStack {
            Color.gray.opacity(0.65).ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Focus Log")
                    .font(.system(size: 58, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(Color.white.opacity(0.55))
                    .overlay {
                        VStack(spacing: 0) {
                            HStack(spacing: 0) {
                                tableHeader(title: "Focus Sessions")
                                tableHeader(title: "Time")
                            }
                            Divider().background(Color.blue.opacity(0.4))

                            ScrollView {
                                VStack(spacing: 0) {
                                    ForEach(missions) { mission in
                                        HStack(spacing: 0) {
                                            tableCell(mission.name)
                                            tableCell("\(mission.duration)m")
                                        }
                                        Divider().background(Color.blue.opacity(0.2))
                                    }
                                }
                            }

                            HStack {
                                Spacer()
                                NavigationLink("Next  →") {
                                    FlightLogDetailView()
                                }
                                .font(.system(size: 38, design: .rounded))
                                .foregroundColor(.black.opacity(0.8))
                            }
                            .padding()
                        }
                        .overlay(alignment: .center) {
                            Rectangle()
                                .fill(Color.blue.opacity(0.35))
                                .frame(width: 3)
                                .padding(.vertical, 12)
                        }
                    }
            }
            .padding(24)
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private func tableHeader(title: String) -> some View {
        Text(title)
            .font(.system(size: 38, weight: .medium, design: .rounded))
            .foregroundColor(.red.opacity(0.75))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
    }

    private func tableCell(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 30, design: .rounded))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
    }
}
