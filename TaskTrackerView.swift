import SwiftUI

struct TaskTrackerView: View {
    
    @State private var tasks: [TaskItem] = []
    
    @State private var newTitle = ""
    @State private var newDueDate = Date()
    @State private var showSheet = false
    
    var body: some View {
        VStack {
            
            List {
                ForEach(tasks) { task in
                    HStack {
                        Button {
                            toggleCompletion(task)
                        } label: {
                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(task.isCompleted ? .green : .gray)
                                .font(.title3)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(task.title)
                                .strikethrough(task.isCompleted)
                            
                            Text("Due: \(task.dueDate.formatted(date: .abbreviated, time: .shortened))")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .onDelete { indexSet in
                    tasks.remove(atOffsets: indexSet)
                }
            }
            
            Button("End Tasks Session") {
                tasks.removeAll()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.red.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding()
        }
        .navigationTitle("Task Tracker")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showSheet) {
            VStack(spacing: 20) {
                Text("New Task")
                    .font(.headline)
                
                TextField("Task name", text: $newTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                DatePicker("Due Date",
                           selection: $newDueDate,
                           displayedComponents: [.date, .hourAndMinute])
                
                Button("Add Task") {
                    if !newTitle.isEmpty {
                        let newTask = TaskItem(
                            title: newTitle,
                            dueDate: newDueDate
                        )
                        tasks.append(newTask)
                        newTitle = ""
                        showSheet = false
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Spacer()
            }
            .padding()
        }
    }
    
    private func toggleCompletion(_ task: TaskItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }
}

