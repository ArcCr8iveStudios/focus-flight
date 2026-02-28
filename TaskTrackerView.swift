import SwiftUI

struct TaskTrackerView: View {
    @State private var tasks: [TaskItem] = [
        TaskItem(title: ".....", dueDate: .now),
        TaskItem(title: ".....", dueDate: .now)
    ]

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.orange.opacity(0.65), Color.orange.opacity(0.95), Color.orange.opacity(0.55)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 22) {
                Text("Task Tracker")
                    .font(.system(size: 58, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color.red.opacity(0.45))
                    .overlay {
                        VStack(spacing: 0) {
                            HStack(spacing: 0) {
                                header("Task Name")
                                header("☑")
                                header("Start")
                                header("Due")
                            }
                            Divider().background(Color.white.opacity(0.7))

                            ForEach(tasks) { task in
                                HStack(spacing: 0) {
                                    cell(task.title)
                                    cell(task.isCompleted ? "☑" : "☐")
                                    cell(task.dueDate.formatted(.dateTime.day().month(.defaultDigits)))
                                    cell(task.dueDate.addingTimeInterval(86_400).formatted(.dateTime.day().month(.defaultDigits)))
                                }
                            }

                            Spacer()
                        }
                        .overlay {
                            HStack(spacing: 0) {
                                Rectangle().fill(Color.white.opacity(0.75)).frame(width: 3)
                                Spacer()
                                Rectangle().fill(Color.white.opacity(0.75)).frame(width: 3)
                                Spacer()
                                Rectangle().fill(Color.white.opacity(0.75)).frame(width: 3)
                            }
                            .padding(.horizontal, 33)
                        }
                    }
            }
            .padding(24)
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private func header(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 34, weight: .medium, design: .rounded))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
    }

    private func cell(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 33, design: .rounded))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
    }
}
