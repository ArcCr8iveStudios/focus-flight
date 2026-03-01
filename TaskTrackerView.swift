import SwiftUI

struct TaskTrackerView: View {
    @Binding var tasks: [TaskItem]

    @State private var newTitle = ""
    @State private var newDueDate = Date()
    @State private var showSheet = false

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.orange.opacity(0.65), Color.orange.opacity(0.95), Color.orange.opacity(0.55)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 22) {
                HStack {
                    Button("←") { dismiss() }
                        .font(.system(size: 42, weight: .medium, design: .rounded))
                        .foregroundColor(.black.opacity(0.85))
                    Spacer()
                }

                Text("Task Tracker")
                    .font(.system(size: 58, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color.red.opacity(0.45))
                    .overlay {
                        VStack(spacing: 0) {
                            HStack {
                                Button("+ Add Task") { showSheet = true }
                                    .font(.system(size: 24, weight: .medium, design: .rounded))

                                Spacer()

                                Button("Clear") { tasks.removeAll() }
                                    .font(.system(size: 24, weight: .medium, design: .rounded))
                                    .opacity(tasks.isEmpty ? 0.5 : 1)
                                    .disabled(tasks.isEmpty)
                            }
                            .foregroundColor(.white)
                            .padding(12)

                            Divider().background(Color.white.opacity(0.7))

                            HStack(spacing: 0) {
                                header("Task Name")
                                header("☑")
                                header("Due")
                            }
                            Divider().background(Color.white.opacity(0.7))

                            if tasks.isEmpty {
                                Text("No tasks yet")
                                    .font(.system(size: 30, design: .rounded))
                                    .foregroundColor(.white.opacity(0.85))
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            } else {
                                ScrollView {
                                    VStack(spacing: 0) {
                                        ForEach(tasks) { task in
                                            HStack(spacing: 0) {
                                                cell(task.title)

                                                Button {
                                                    toggleCompletion(task)
                                                } label: {
                                                    Text(task.isCompleted ? "☑" : "☐")
                                                        .font(.system(size: 33, design: .rounded))
                                                        .foregroundColor(.white)
                                                        .frame(maxWidth: .infinity)
                                                        .padding(.vertical, 10)
                                                }
                                                .buttonStyle(.plain)

                                                cell(task.dueDate.formatted(.dateTime.day().month(.defaultDigits)))
                                            }
                                            .background(task.isCompleted ? Color.green.opacity(0.2) : .clear)
                                            Divider().background(Color.white.opacity(0.45))
                                        }
                                    }
                                }
                            }
                        }
                        .overlay {
                            HStack(spacing: 0) {
                                Rectangle().fill(Color.white.opacity(0.75)).frame(width: 3)
                                Spacer()
                                Rectangle().fill(Color.white.opacity(0.75)).frame(width: 3)
                            }
                            .padding(.horizontal, 55)
                        }
                    }
            }
            .padding(24)
        }
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $showSheet) {
            VStack(spacing: 18) {
                Text("New Task")
                    .font(.title2.bold())

                TextField("Task name", text: $newTitle)
                    .textFieldStyle(.roundedBorder)

                DatePicker("Due Date", selection: $newDueDate, displayedComponents: [.date])

                Button("Add") {
                    guard !newTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                    tasks.append(TaskItem(title: newTitle, dueDate: newDueDate))
                    newTitle = ""
                    newDueDate = Date()
                    showSheet = false
                }
                .buttonStyle(.borderedProminent)

                Spacer()
            }
            .padding()
            .presentationDetents([.fraction(0.45)])
        }
    }

    private func toggleCompletion(_ task: TaskItem) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[index].isCompleted.toggle()
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
