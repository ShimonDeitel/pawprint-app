import Foundation
import Combine

final class PawprintStore: ObservableObject {
    static let freeTierLimit = 20

    @Published var visits: [VetVisit] = [] { didSet { persist() } }

    private let fileURL: URL

    init() {
        let support = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: support, withIntermediateDirectories: true)
        fileURL = support.appendingPathComponent("pawprintstore.json")
        load()
    }

    var isAtFreeLimit: Bool { visits.count >= Self.freeTierLimit }

    func canAdd(isPro: Bool) -> Bool {
        isPro || visits.count < Self.freeTierLimit
    }

    func add(_ entry: VetVisit, isPro: Bool) -> Bool {
        guard canAdd(isPro: isPro) else { return false }
        visits.append(entry)
        return true
    }

    func remove(at offsets: IndexSet) {
        visits.remove(atOffsets: offsets)
    }

    func update(_ entry: VetVisit) {
        if let idx = visits.firstIndex(where: { $0.id == entry.id }) {
            visits[idx] = entry
        }
    }

    private func seedIfNeeded() {
        if visits.isEmpty {
            visits = [Self.sampleSeed]
        }
    }

    private func persist() {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        if let data = try? encoder.encode(PersistedState(visits: visits)) {
            try? data.write(to: fileURL)
        }
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL) else {
            seedIfNeeded()
            return
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        if let state = try? decoder.decode(PersistedState.self, from: data) {
            self.visits = state.visits
            
        }
        seedIfNeeded()
    }

    struct PersistedState: Codable {
        var visits: [VetVisit]
        
    }
    static let sampleSeed = VetVisit(petName: "Buddy", date: Date(), reason: "Annual checkup", notes: "All healthy")
}
