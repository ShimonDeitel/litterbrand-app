import Foundation

struct FoodEntry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var brand: String
    var flavor: String
    var rating: Int
    var createdAt: Date = Date()
}
