import Foundation

nonisolated protocol FeatureFlagAPI: Sendable {
    func fetchFlags() async throws -> FeatureFlagsResponse
}

nonisolated struct MockFeatureFlagAPI: FeatureFlagAPI {
    func fetchFlags() async throws -> FeatureFlagsResponse {
        try await Task.sleep(for: .milliseconds(700))

        let backendJSON = """
        {
            "newCheckout": true,
            "newProfile": false,
            "showReferralBanner": true,
            "checkoutVariant": "experimentB"
        }
        """

        let data = Data(backendJSON.utf8)
        return try JSONDecoder().decode(FeatureFlagsResponse.self, from: data)
    }
}
