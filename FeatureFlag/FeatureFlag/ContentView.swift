import SwiftUI

struct ContentView: View {
    @State private var viewModel: ContentViewModel

    @MainActor
    init() {
        _viewModel = State(initialValue: ContentViewModel())
    }

    @MainActor
    init(viewModel: ContentViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            List {
                referralSection
                featureSection
                checkoutSection
            }
            .navigationTitle("Feature Flags")
            .toolbar {
                Button("Refresh") {
                    Task {
                        await viewModel.refreshFlags()
                    }
                }
                .disabled(viewModel.isRefreshing)
            }
            .overlay {
                if viewModel.isRefreshing {
                    ProgressView("Refreshing flags")
                        .padding()
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            .task {
                await viewModel.loadCachedFlags()
                await viewModel.refreshFlags()
            }
            .alert("Feature Flag Error", isPresented: hasErrorMessage) {
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            } message: {
                Text(viewModel.errorMessage ?? "Unknown error")
            }
        }
    }

    private var referralSection: some View {
        Section("Remote Content") {
            if viewModel.snapshot.isEnabled(.showReferralBanner) {
                Label("Invite a friend and earn rewards", systemImage: "gift.fill")
                    .foregroundStyle(.green)
            } else {
                Text("Referral banner is disabled")
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var featureSection: some View {
        Section("Boolean Flags") {
            ForEach(FeatureFlag.allCases) { flag in
                HStack {
                    Text(flag.title)
                    Spacer()
                    Text(viewModel.snapshot.isEnabled(flag) ? "Enabled" : "Disabled")
                        .foregroundStyle(viewModel.snapshot.isEnabled(flag) ? .green : .secondary)
                }
            }
        }
    }

    private var checkoutSection: some View {
        Section("A/B Checkout Variant") {
            switch viewModel.snapshot.checkoutVariant {
            case .old:
                CheckoutVariantRow(title: "Old checkout flow", systemImage: "cart")
            case .new:
                CheckoutVariantRow(title: "New checkout flow", systemImage: "cart.fill")
            case .experimentB:
                CheckoutVariantRow(title: "Experiment B checkout", systemImage: "sparkles")
            }
        }
    }

    private var hasErrorMessage: Binding<Bool> {
        Binding(
            get: { viewModel.errorMessage != nil },
            set: { isPresented in
                if !isPresented {
                    viewModel.errorMessage = nil
                }
            }
        )
    }
}

private struct CheckoutVariantRow: View {
    let title: String
    let systemImage: String

    var body: some View {
        Label(title, systemImage: systemImage)
    }
}

#Preview {
    ContentView()
}
