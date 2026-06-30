import Foundation

struct TransactionFilter: Hashable {
    var category = ""
    var type: TransactionType?
    var dateFrom = ""
    var dateTo = ""
}

@MainActor
final class TransactionsViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    @Published var filter = TransactionFilter()
    @Published var transactions: [Transaction] = []
    @Published var showFilter = false
    @Published var selectedTransaction: Transaction?
    @Published var showFeedbackSheet = false
    @Published var successMessage: String?

    private let service: TransactionsService
    private let bankingService: BankingService

    init(
        service: TransactionsService = TransactionsService(),
        bankingService: BankingService = BankingService()
    ) {
        self.service = service
        self.bankingService = bankingService
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            async let manual = service.fetchTransactions()
            async let bank = bankingService.fetchTransactions()
            let (manualTransactions, bankTransactions) = try await (manual, bank)
            transactions = mergeTransactions(manual: manualTransactions, bank: bankTransactions)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    var filtered: [Transaction] {
        transactions.filter { tx in
            let matchesSearch = searchText.isEmpty || tx.description.localizedCaseInsensitiveContains(searchText) || tx.merchant.localizedCaseInsensitiveContains(searchText)
            let matchesCategory = filter.category.isEmpty || tx.category == filter.category
            let matchesType = filter.type == nil || tx.type == filter.type
            return matchesSearch && matchesCategory && matchesType
        }
    }

    var grouped: [(String, [Transaction])] {
        let groups = Dictionary(grouping: filtered, by: \.date)
        return groups.keys.sorted(by: >).map { ($0, groups[$0] ?? []) }
    }

    var totalSpent: Double { filtered.filter { $0.type.isExpense }.reduce(0) { $0 + $1.amount } }
    var totalIncome: Double { filtered.filter { $0.type == .income }.reduce(0) { $0 + $1.amount } }
    var net: Double { totalIncome - totalSpent }
    var categories: [String] { Array(Set(transactions.map(\.category))).sorted() }

    func save(transaction: Transaction) async {
        do {
            let updated: Transaction
            if transaction.source == "manual" && !transaction.id.isEmpty {
                updated = try await service.updateTransaction(transaction)
            } else {
                updated = try await service.createTransaction(transaction)
            }
            if let idx = transactions.firstIndex(where: { $0.id == updated.id }) {
                transactions[idx] = updated
            } else {
                transactions.insert(updated, at: 0)
            }
            successMessage = "Transaction saved."
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func delete(transactionId: String) async {
        do {
            try await service.deleteTransaction(id: transactionId)
            transactions.removeAll { $0.id == transactionId }
            successMessage = "Transaction deleted."
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func submitFeedback(_ feedback: TransactionFeedback) async {
        guard let selectedTransaction else { return }
        do {
            if selectedTransaction.source == "bank" {
                _ = try await bankingService.submitBankTransactionFeedback(transactionId: selectedTransaction.id, feedback: feedback)
                await load()
            } else {
                let updated = try await service.submitFeedback(transactionId: selectedTransaction.id, feedback: feedback)
                if let idx = transactions.firstIndex(where: { $0.id == updated.id }) {
                    transactions[idx] = updated
                }
            }
            showFeedbackSheet = false
            successMessage = "Feedback submitted."
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func mergeTransactions(manual: [Transaction], bank: [BankTransaction]) -> [Transaction] {
        let normalizedBank = bank
            .filter { !$0.removed }
            .map { bankTx in
                Transaction(
                    id: "bank-\(bankTx.id)",
                    description: bankTx.description.isEmpty ? bankTx.merchant : bankTx.description,
                    merchant: bankTx.merchant,
                    category: bankTx.category,
                    amount: bankTx.amount,
                    currency: bankTx.currency,
                    type: bankTx.direction,
                    date: bankTx.date,
                    valueScore: bankTx.valueScore,
                    satisfaction: nil,
                    feedback: nil,
                    source: "bank",
                    createdAt: bankTx.date,
                    updatedAt: bankTx.date,
                    backendDirection: bankTx.direction.rawValue,
                    paymentChannel: nil
                )
            }

        return (manual + normalizedBank).sorted { $0.date > $1.date }
    }
}
