import SwiftUI

struct FlightLogDetailView: View {
    let tasks: [TaskItem]

    @Environment(\.dismiss) private var dismiss

    private var completedTasks: [TaskItem] {
        tasks.filter { $0.isCompleted }
    }

    var body: some View {
        ZStack {
            Color.gray.opacity(0.65).ignoresSafeArea()

            VStack(spacing: 24) {
                HStack {
                    Button("←") { dismiss() }
                        .font(.system(size: 42, weight: .medium, design: .rounded))
                        .foregroundColor(.black.opacity(0.85))
                    Spacer()
                }

                Text("Tasks Done")
                    .font(.system(size: 58, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(Color.white.opacity(0.55))
                    .overlay {
                        VStack(spacing: 0) {
                            HStack(spacing: 0) {
                                header("Task")
                                header("Due")
                            }
                            Divider().background(Color.blue.opacity(0.4))

                            if completedTasks.isEmpty {
                                Text("No completed tasks yet")
                                    .font(.system(size: 26, design: .rounded))
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            } else {
                                ScrollView {
                                    VStack(spacing: 0) {
                                        ForEach(completedTasks) { task in
                                            HStack(spacing: 0) {
                                                cell(task.title, color: .black)
                                                cell(task.dueDate.formatted(.dateTime.day().month(.defaultDigits)), color: .black)
                                            }
                                            Divider().background(Color.blue.opacity(0.2))
                                        }
                                    }
                                }
                            }

                            HStack {
                                Button("← Back") { dismiss() }
                                    .font(.system(size: 36, design: .rounded))
                                    .foregroundColor(.black.opacity(0.8))
                                Spacer()
                            }
                            .padding()
                        }
                        .overlay {
                            Rectangle().fill(Color.blue.opacity(0.35)).frame(width: 3)
                        }
                    }
            }
            .padding(24)
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private func header(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 38, weight: .medium, design: .rounded))
            .foregroundColor(.orange)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
    }

    private func cell(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.system(size: 24, design: .rounded))
            .foregroundColor(color)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
    }
}
