import Foundation
import Observation

@MainActor
@Observable
final class ContentViewModel {
    private(set) var snapshot: FeatureFlagsSnapshot = .fallback
    private(set) var isRefreshing = false
    var errorMessage: String?

    private let featureManager: FeatureFlagManaging

    init() {
        featureManager = FeatureFlagManager()
    }

    init(featureManager: FeatureFlagManaging) {
        self.featureManager = featureManager
    }

    func loadCachedFlags() async {
        snapshot = await featureManager.currentSnapshot()
    }

    func refreshFlags() async {
        isRefreshing = true
        errorMessage = nil

        do {
            try await featureManager.refreshFlags()
            snapshot = await featureManager.currentSnapshot()
        } catch {
            errorMessage = "Could not refresh flags. Using cached values."
        }

        isRefreshing = false
    }
}
