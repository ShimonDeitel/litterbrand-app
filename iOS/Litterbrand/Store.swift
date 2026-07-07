import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    static let freeLimit = 8 // seed data has 3 entries; keep this above that

    @Published var entries: [FoodEntry] = []
    @Published var isPro: Bool = false

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("litterbrand_entries.json")
        load()
    }

    var canAddMore: Bool {
        isPro || entries.count < Store.freeLimit
    }

    func add(_ entry: FoodEntry) {
        entries.insert(entry, at: 0)
        save()
    }

    func update(_ entry: FoodEntry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: FoodEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    private func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([FoodEntry].self, from: data) {
            entries = decoded
        } else {
            entries = [
        FoodEntry(brand: "Sample 1", flavor: "Sample 1", rating: 1),
        FoodEntry(brand: "Sample 2", flavor: "Sample 2", rating: 2),
        FoodEntry(brand: "Sample 3", flavor: "Sample 3", rating: 3)
            ]
            save()
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(entries) {
            try? data.write(to: fileURL)
        }
    }
}
