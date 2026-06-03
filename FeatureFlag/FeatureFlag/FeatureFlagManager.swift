import Foundation

protocol FeatureFlagManaging: Sendable {
    func isEnabled(_ flag: FeatureFlag) async -> Bool
    func checkoutVariant() async -> CheckoutVariant
    func currentSnapshot() async -> FeatureFlagsSnapshot
    func refreshFlags() async throws
}

actor FeatureFlagManager: FeatureFlagManaging {
    private let api: FeatureFlagAPI
    private let store: FeatureFlagStoring
    private var snapshot: FeatureFlagsSnapshot

    init(
        api: FeatureFlagAPI = MockFeatureFlagAPI(),
        store: FeatureFlagStoring = UserDefaultsFeatureFlagStore()
    ) {
        self.api = api
        self.store = store
        snapshot = store.load() ?? .fallback
    }

    func isEnabled(_ flag: FeatureFlag) -> Bool {
        snapshot.isEnabled(flag)
    }

    func checkoutVariant() -> CheckoutVariant {
        snapshot.checkoutVariant
    }

    func currentSnapshot() -> FeatureFlagsSnapshot {
        snapshot
    }

    func refreshFlags() async throws {
        let response = try await api.fetchFlags()
        let latestSnapshot = response.snapshot
        snapshot = latestSnapshot
        store.save(latestSnapshot)
    }
}
