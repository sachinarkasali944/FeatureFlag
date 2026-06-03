import Foundation

nonisolated protocol FeatureFlagStoring: Sendable {
    func load() -> FeatureFlagsSnapshot?
    func save(_ snapshot: FeatureFlagsSnapshot)
}

nonisolated struct UserDefaultsFeatureFlagStore: FeatureFlagStoring, @unchecked Sendable {
    private let key: String
    private let userDefaults: UserDefaults

    init(
        key: String = "cachedFeatureFlags",
        userDefaults: UserDefaults = .standard
    ) {
        self.key = key
        self.userDefaults = userDefaults
    }

    func load() -> FeatureFlagsSnapshot? {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }

        return try? JSONDecoder().decode(FeatureFlagsSnapshot.self, from: data)
    }

    func save(_ snapshot: FeatureFlagsSnapshot) {
        guard let data = try? JSONEncoder().encode(snapshot) else {
            return
        }

        userDefaults.set(data, forKey: key)
    }
}
