import Foundation

struct Mission: Identifiable {
    let id = UUID()
    var name: String
    var duration: Int
    var date: Date
    var isActive: Bool = true
    var isCompleted: Bool = false
}
