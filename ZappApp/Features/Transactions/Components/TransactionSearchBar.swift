import SwiftUI

struct TransactionSearchBar: View {
    @Binding var query: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass").foregroundStyle(AppColors.textSecondary)
            TextField("Search transactions...", text: $query)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
        }
        .padding(AppSpacing.md)
        .background(AppColors.subtle)
        .cornerRadius(AppRadii.md)
    }
}
