import SwiftUI

struct AssistantScreen: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AssistantViewModel()
    private let typingIndicatorID = "typing-indicator"

    private func scrollToBottom(_ proxy: ScrollViewProxy) {
        if viewModel.isTyping {
            proxy.scrollTo(typingIndicatorID, anchor: .bottom)
        } else if let lastID = viewModel.messages.last?.id {
            proxy.scrollTo(lastID, anchor: .bottom)
        }
    }

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
                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVStack(spacing: AppSpacing.md) {
                                ForEach(viewModel.messages) { message in
                                    MessageBubble(message: message) { action in
                                        Task { await viewModel.sendQuickAction(action) }
                                    }
                                    .id(message.id)
                                }
                                if viewModel.isTyping {
                                    TypingIndicator()
                                        .id(typingIndicatorID)
                                }
                            }
                        }
                        .onChange(of: viewModel.messages.count) { _ in
                            withAnimation { scrollToBottom(proxy) }
                        }
                        .onChange(of: viewModel.isTyping) { _ in
                            withAnimation { scrollToBottom(proxy) }
                        }
                    }
                }

                if let errorMessage = viewModel.errorMessage, !viewModel.messages.isEmpty {
                    Text(errorMessage)
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.error)
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
