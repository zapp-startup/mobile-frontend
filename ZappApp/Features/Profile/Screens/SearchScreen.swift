import SwiftUI

struct SearchScreen: View {
    @StateObject private var viewModel = SearchViewModel()

    var body: some View {
        AppScreen {
            VStack(spacing: AppSpacing.lg) {
                AppHeader(title: "Search", subtitle: "Explore finance insights, settings, and tools.")
                AppInput(title: "Search", value: $viewModel.query)
                AppCard {
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text("Suggestions").font(AppTypography.sectionTitle)
                        if viewModel.filteredSuggestions.isEmpty {
                            Text("No matches").font(AppTypography.helper).foregroundStyle(AppColors.textMuted)
                        }
                        ForEach(viewModel.filteredSuggestions, id: \.self) { suggestion in
                            Text(suggestion).font(AppTypography.helper).foregroundStyle(AppColors.textSecondary)
                        }
                    }
                }
                Spacer()
            }
        }
    }
}
