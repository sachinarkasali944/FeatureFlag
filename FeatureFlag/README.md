# Feature Flag Manager

A small SwiftUI learning project that demonstrates how to design a type-safe feature flag system for iOS apps.

The project is based on a common low-level design interview question: how can an app enable or disable features remotely, roll out changes gradually, and avoid App Store releases for small product changes?

## What This Project Shows

- Fetching feature flags from a backend API
- Caching the latest flags locally for offline startup
- Type-safe access with enums instead of raw string keys
- A/B testing with typed variants
- Actor-based shared state protection
- Dependency injection for testability
- Swift Testing coverage for the manager

## Core Design

### Type-Safe Flags

Instead of accessing flags with strings like this:

```swift
if flags["newCheckout"] == true {
    // show new checkout
}
```

The app defines flags as an enum:

```swift
enum FeatureFlag: String, CaseIterable, Codable, Identifiable {
    case newCheckout
    case newProfile
    case showReferralBanner
}
```

This avoids typos, makes flags discoverable, and lets the compiler help when code changes.

### Backend Response

The mock backend response looks like this:

```json
{
    "newCheckout": true,
    "newProfile": false,
    "showReferralBanner": true,
    "checkoutVariant": "experimentB"
}
```

`FeatureFlagsResponse` decodes the response and converts it into a `FeatureFlagsSnapshot`, which is the app's local representation of the current flag state.

### Feature Flag Manager

`FeatureFlagManager` is an actor because feature flags may be read and updated from multiple places:

- App launch
- Pull to refresh
- Background sync
- Multiple SwiftUI screens

The actor owns the shared snapshot and exposes a small API:

```swift
protocol FeatureFlagManaging: Sendable {
    func isEnabled(_ flag: FeatureFlag) async -> Bool
    func checkoutVariant() async -> CheckoutVariant
    func currentSnapshot() async -> FeatureFlagsSnapshot
    func refreshFlags() async throws
}
```

### Offline Support

The manager loads cached flags from `UserDefaultsFeatureFlagStore` during initialization.

Startup flow:

```text
App Launch
   -> Read cached flags
   -> Show UI immediately
   -> Refresh from backend
   -> Save latest flags locally
```

If refresh fails, the app continues using the cached or fallback values.

### A/B Testing

Boolean flags are good for simple on/off features. For experiments, the project uses a typed variant:

```swift
enum CheckoutVariant: String, Codable, CaseIterable, Identifiable {
    case old
    case new
    case experimentB
}
```

Usage stays explicit and safe:

```swift
switch snapshot.checkoutVariant {
case .old:
    OldCheckoutView()
case .new:
    NewCheckoutView()
case .experimentB:
    ExperimentalCheckoutView()
}
```

## File Guide

- `FeatureFlag.swift`: type-safe feature flag and experiment enums
- `FeatureFlagsSnapshot.swift`: current flag state and backend response mapping
- `FeatureFlagAPI.swift`: backend API abstraction and mock API response
- `FeatureFlagStore.swift`: local cache abstraction and UserDefaults implementation
- `FeatureFlagManager.swift`: actor that fetches, caches, and exposes flags
- `ContentViewModel.swift`: SwiftUI-facing view model
- `ContentView.swift`: sample UI showing boolean flags and checkout variants
- `FeatureFlagTests.swift`: unit tests for fallback, refresh, and caching behavior

## Interview Summary

A scalable feature flag system should centralize remote configuration in a manager, expose type-safe access, cache the last successful response for offline usage, and avoid leaking backend string keys throughout the app.

Using an actor protects shared state when flags are refreshed and read concurrently. Using protocols for the API and cache keeps the manager easy to test and easy to replace with real networking later.

## Next Improvements

- Replace `MockFeatureFlagAPI` with a real `URLSession` implementation
- Add percentage rollout support based on stable user IDs
- Add environment-specific flag files for development and staging
- Add analytics events for experiment exposure tracking
