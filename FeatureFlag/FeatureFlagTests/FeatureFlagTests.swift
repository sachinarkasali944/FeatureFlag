import Testing
@testable import FeatureFlag

struct FeatureFlagTests {
    @Test func managerUsesFallbackValuesBeforeRefresh() async throws {
        let manager = FeatureFlagManager(
            api: StaticFeatureFlagAPI(response: .enabledExperiment),
            store: InMemoryFeatureFlagStore()
        )

        await #expect(manager.isEnabled(.newCheckout) == false)
        await #expect(manager.checkoutVariant() == .old)
    }

    @Test func managerRefreshesFromAPIAndCachesSnapshot() async throws {
        let store = InMemoryFeatureFlagStore()
        let manager = FeatureFlagManager(
            api: StaticFeatureFlagAPI(response: .enabledExperiment),
            store: store
        )

        try await manager.refreshFlags()

        await #expect(manager.isEnabled(.newCheckout) == true)
        await #expect(manager.isEnabled(.newProfile) == false)
        await #expect(manager.isEnabled(.showReferralBanner) == true)
        await #expect(manager.checkoutVariant() == .experimentB)
        #expect(store.savedSnapshot == FeatureFlagsResponse.enabledExperiment.snapshot)
    }
}

private struct StaticFeatureFlagAPI: FeatureFlagAPI {
    let response: FeatureFlagsResponse

    func fetchFlags() async throws -> FeatureFlagsResponse {
        response
    }
}

private final class InMemoryFeatureFlagStore: FeatureFlagStoring, @unchecked Sendable {
    private(set) var savedSnapshot: FeatureFlagsSnapshot?

    func load() -> FeatureFlagsSnapshot? {
        savedSnapshot
    }

    func save(_ snapshot: FeatureFlagsSnapshot) {
        savedSnapshot = snapshot
    }
}

private extension FeatureFlagsResponse {
    static let enabledExperiment = FeatureFlagsResponse(
        newCheckout: true,
        newProfile: false,
        showReferralBanner: true,
        checkoutVariant: .experimentB
    )
}
