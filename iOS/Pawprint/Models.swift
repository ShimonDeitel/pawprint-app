import Foundation

struct VetVisit: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    var petName: String
    var date: Date = Date()
    var reason: String
    var notes: String = ""
    var followUpDate: Date?
}
