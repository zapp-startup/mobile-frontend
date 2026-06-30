import SwiftUI

struct AssistantScreen: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AssistantViewModel()

    var body: some View {
        AppScreen {
            VStack(spacing: AppSpacing.md) {
                AssistantHeader(
                    onNewChat: { Task { await viewModel.newChat() } },
                    onClose: { dismiss() }
                )

                if viewModel.isLoading && viewModel.messages.isEmpty {
                    AppLoadingState(title: "Loading chat", message: "Preparing assistant context.")
                } else if let errorMessage = viewModel.errorMessage, viewModel.messages.isEmpty {
                    AppErrorState(title: "Assistant Error", message: errorMessage) {
                        Task { await viewModel.load() }
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: AppSpacing.md) {
                            ForEach(viewModel.messages) { message in
                                MessageBubble(message: message) { action in
                                    Task { await viewModel.sendQuickAction(action) }
                                }
                            }
                            if viewModel.isTyping {
                                TypingIndicator()
                            }
                        }
                    }
                }

                ComposerBar(text: $viewModel.draftMessage) {
                    Task { await viewModel.sendDraft() }
                }
            }
            .task { await viewModel.load() }
        }
    }
}

#Preview {
    AssistantScreen()
}
