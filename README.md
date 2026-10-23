# Feature Flag Manager

> Typed feature flags, cached startup state, and experiment variants in SwiftUI.

A learning app that places flag-fetching and caching behind protocols and protects shared state with an actor.

## Highlights

- Boolean feature flags and typed checkout variants.
- UserDefaults-backed cached snapshots.
- Actor-isolated refresh and shared state.
- Injectable API/store abstractions and included test sources.

## Open and run

1. Clone this repository and open `FeatureFlag/FeatureFlag.xcodeproj` in Xcode.
2. Select the app scheme and a simulator compatible with the deployment target in **Build Settings → iOS Deployment Target**. Use an Xcode version with SDK support for that target.
3. Build and run with **⌘R**. For a physical device, select your development team.

```bash
git clone https://github.com/sachinarkasali944/FeatureFlag.git
cd FeatureFlag
open "FeatureFlag/FeatureFlag.xcodeproj"
```

## Demo scope

The shipped API implementation uses a delayed mock JSON response. Connecting a real backend and percentage rollouts remain extensions.

## Explore the code

- [Xcode project](./FeatureFlag/FeatureFlag.xcodeproj)
- [Project files](./FeatureFlag)

## Further reading

[Read the detailed implementation guide](./FeatureFlag/README.md).
