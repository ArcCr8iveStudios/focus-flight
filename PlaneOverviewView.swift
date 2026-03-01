import SwiftUI

struct PlaneOverviewView: View {
    let missions: [Mission]

    @Environment(\.dismiss) private var dismiss

    private var completedMinutes: Int {
        missions.filter { $0.isCompleted }.reduce(0) { $0 + $1.duration }
    }

    private var currentIndex: Int {
        PlaneCatalog.level(forTotalMinutes: completedMinutes)
    }

    private var currentPlane: PlaneTier {
        PlaneCatalog.tiers[currentIndex]
    }

    private var progress: Double {
        PlaneCatalog.progress(totalMinutes: completedMinutes)
    }

    var body: some View {
        ZStack {
            Color.gray.opacity(0.65).ignoresSafeArea()

            VStack(spacing: 20) {
                HStack {
                    Button("←") { dismiss() }
                        .font(.system(size: 42, weight: .medium, design: .rounded))
                        .foregroundColor(.black.opacity(0.85))
                    Spacer()
                }

                Text("Aircraft Upgrade")
                    .font(.system(size: 54, weight: .medium, design: .rounded))
                    .foregroundColor(.red.opacity(0.65))

                Text(currentPlane.name)
                    .font(.system(size: 46, weight: .medium, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)

                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(Color.blue.opacity(0.45))
                    .overlay {
                        VStack(spacing: 14) {
                            Image(currentPlane.assetName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 230)
                                .overlay {
                                    if currentPlane.assetName.isEmpty {
                                        Image(systemName: currentPlane.symbol)
                                            .resizable()
                                            .scaledToFit()
                                            .padding(20)
                                    }
                                }

                            Text("Specs")
                                .font(.system(size: 48, weight: .bold, design: .rounded))

                            Text(currentPlane.power)
                            Text(currentPlane.wingspan)
                            Text(currentPlane.weight)
                        }
                        .font(.system(size: 32, design: .rounded))
                        .foregroundColor(.black.opacity(0.85))
                    }
                    .frame(height: 420)

                Text("Plane \(currentIndex + 1) of \(PlaneCatalog.tiers.count)")
                    .font(.headline)

                ProgressView(value: progress)
                    .tint(.blue)
                    .scaleEffect(x: 1, y: 2, anchor: .center)
                    .padding(.horizontal, 12)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(Array(PlaneCatalog.tiers.enumerated()), id: \.offset) { index, plane in
                            Text(plane.name)
                                .font(.system(size: 15, weight: index == currentIndex ? .bold : .regular, design: .rounded))
                                .foregroundColor(index == currentIndex ? .white : .black.opacity(0.75))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(index == currentIndex ? Color.blue.opacity(0.8) : Color.white.opacity(0.45))
                                .clipShape(Capsule())
                        }
                    }
                }

                Spacer()
            }
            .padding(24)
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}
