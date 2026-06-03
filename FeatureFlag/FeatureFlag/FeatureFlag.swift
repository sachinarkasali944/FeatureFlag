import Foundation

nonisolated enum FeatureFlag: String, CaseIterable, Codable, Identifiable, Sendable {
    case newCheckout
    case newProfile
    case showReferralBanner

    var id: String { rawValue }

    var title: String {
        switch self {
        case .newCheckout:
            "New Checkout"
        case .newProfile:
            "New Profile"
        case .showReferralBanner:
            "Referral Banner"
        }
    }
}

nonisolated enum CheckoutVariant: String, Codable, CaseIterable, Identifiable, Sendable {
    case old
    case new
    case experimentB

    var id: String { rawValue }

    var title: String {
        switch self {
        case .old:
            "Old Checkout"
        case .new:
            "New Checkout"
        case .experimentB:
            "Experiment B"
        }
    }
}
