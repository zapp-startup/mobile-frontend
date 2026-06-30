import SwiftUI

struct PreferencesList: View {
    let preferences: [Preference]
    var onAdd: () -> Void
    var onRemove: (Preference) -> Void

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                SectionHeader(title: "Preferences", actionTitle: "Add", action: onAdd)
                if preferences.isEmpty {
                    Text("No preferences set").font(AppTypography.helper).foregroundStyle(AppColors.textSecondary)
                } else {
                    ForEach(preferences) { preference in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(preference.key).font(AppTypography.cardTitle)
                                Text("\(preference.value) • \(preference.category)")
                                    .font(AppTypography.caption)
                                    .foregroundStyle(AppColors.textSecondary)
                            }
                            Spacer()
                            Button("Remove") { onRemove(preference) }
                                .font(AppTypography.caption)
                                .foregroundStyle(AppColors.error)
                        }
                    }
                }
            }
        }
    }
}
