import Foundation

nonisolated struct FeatureFlagsSnapshot: Codable, Equatable, Sendable {
    var flags: [FeatureFlag: Bool]
    var checkoutVariant: CheckoutVariant

    static let fallback = FeatureFlagsSnapshot(
        flags: [
            .newCheckout: false,
            .newProfile: false,
            .showReferralBanner: false
        ],
        checkoutVariant: .old
    )

    func isEnabled(_ flag: FeatureFlag) -> Bool {
        flags[flag] ?? false
    }
}

nonisolated struct FeatureFlagsResponse: Decodable, Sendable {
    let newCheckout: Bool
    let newProfile: Bool
    let showReferralBanner: Bool
    let checkoutVariant: CheckoutVariant

    var snapshot: FeatureFlagsSnapshot {
        FeatureFlagsSnapshot(
            flags: [
                .newCheckout: newCheckout,
                .newProfile: newProfile,
                .showReferralBanner: showReferralBanner
            ],
            checkoutVariant: checkoutVariant
        )
    }
}
