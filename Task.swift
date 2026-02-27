import Foundation

struct TaskItem: Identifiable {
    let id = UUID()
    var title: String
    var dueDate: Date
    var isCompleted: Bool = false
}
