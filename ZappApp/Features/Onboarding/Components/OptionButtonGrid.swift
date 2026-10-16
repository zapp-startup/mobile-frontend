import SwiftUI

struct OptionButtonGrid: View {
    let options: [String]
    let selected: Set<String>
    var allowsMultiple = false
    let onSelect: (String) -> Void

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: AppSpacing.sm) {
            ForEach(options, id: \.self) { option in
                Button(action: { onSelect(option) }) {
                    Text(option)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppSpacing.md)
                        .background(selected.contains(option) ? AppColors.accent.opacity(0.2) : AppColors.subtle)
                        .foregroundStyle(selected.contains(option) ? AppColors.accent : AppColors.textPrimary)
                        .cornerRadius(AppRadii.md)
                }
                .buttonStyle(.plain)
            }
        }
    }
}
