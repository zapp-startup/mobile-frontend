import React, { useState } from 'react';
import { useNavigate } from 'react-router';
import { Plus, Filter, Building2 } from 'lucide-react';
import { AppScreen } from '../../../shared/components/AppScreen';
import { AppHeader } from '../../../shared/components/AppHeader';
import { AppButton } from '../../../shared/components/AppButton';
import { TransactionSearchBar } from '../components/TransactionSearchBar';
import { TransactionMetricRow } from '../components/TransactionMetricRow';
import { TransactionFilterSheet } from '../components/TransactionFilterSheet';
import { TransactionGroupSection } from '../components/TransactionGroupSection';
import { SpendingCalendarCard } from '../components/SpendingCalendarCard';
import { Transaction } from '../../../shared/utils/mockShapes';
import { colors } from '../../../shared/theme/colors';

export const TransactionsScreen: React.FC = () => {
  const navigate = useNavigate();
  const [searchQuery, setSearchQuery] = useState('');
  const [filterSheetOpen, setFilterSheetOpen] = useState(false);
  const [filters, setFilters] = useState({ category: '', type: '', dateFrom: '', dateTo: '' });

  // Mock data
  const mockTransactions: Transaction[] = [
    { id: '1', description: 'Whole Foods', amount: -67.42, type: 'expense', category: 'Groceries', date: '2026-04-15', valueScore: 78 },
    { id: '2', description: 'Salary Deposit', amount: 5000, type: 'income', category: 'Income', date: '2026-04-15' },
    { id: '3', description: 'Netflix', amount: -15.99, type: 'expense', category: 'Subscriptions', date: '2026-04-14', valueScore: 85 },
    { id: '4', description: 'Uber', amount: -23.15, type: 'expense', category: 'Transportation', date: '2026-04-14', valueScore: 65 },
    { id: '5', description: 'Starbucks', amount: -5.75, type: 'expense', category: 'Dining', date: '2026-04-13', valueScore: 45 },
  ];

  const groupedTransactions = mockTransactions.reduce((groups: Record<string, Transaction[]>, transaction) => {
    const date = transaction.date;
    if (!groups[date]) groups[date] = [];
    groups[date].push(transaction);
    return groups;
  }, {});

  const spendingData = Array.from({ length: 30 }, (_, i) => ({
    date: `2026-03-${i + 1}`,
    amount: Math.random() * 150,
  }));

  return (
    <AppScreen>
      <AppHeader
        title="Transactions"
        rightActions={
          <button
            onClick={() => navigate('/transactions/new')}
            className="p-2 rounded-lg active:opacity-70 transition-opacity"
            style={{ color: colors.accent }}
          >
            <Plus size={20} />
          </button>
        }
      />

      <div className="px-4 py-6 space-y-4">
        <TransactionSearchBar value={searchQuery} onChange={setSearchQuery} />

        <TransactionMetricRow
          totalCount={mockTransactions.length}
          totalSpent={107.31}
          totalIncome={5000}
          netAmount={4892.69}
        />

        <button
          onClick={() => setFilterSheetOpen(true)}
          className="flex items-center gap-2 px-4 py-2 rounded-lg active:opacity-70 transition-opacity"
          style={{
            backgroundColor: colors.elevatedSurface,
            color: colors.primaryText,
            border: `1px solid ${colors.mutedBorder}`,
          }}
        >
          <Filter size={16} />
          <span>Filters</span>
        </button>

        <SpendingCalendarCard data={spendingData} />

        {Object.entries(groupedTransactions).map(([date, transactions]) => (
          <TransactionGroupSection
            key={date}
            date={new Date(date).toLocaleDateString('en-US', { month: 'long', day: 'numeric', year: 'numeric' })}
            transactions={transactions}
            onTransactionClick={(t) => navigate(`/transactions/${t.id}`)}
          />
        ))}

        <AppButton
          variant="secondary"
          fullWidth
          onClick={() => navigate('/transactions/banking')}
        >
          <Building2 size={20} className="inline mr-2" />
          Bank Connections
        </AppButton>
      </div>

      <TransactionFilterSheet
        isOpen={filterSheetOpen}
        onClose={() => setFilterSheetOpen(false)}
        filters={filters}
        onApply={setFilters}
      />
    </AppScreen>
  );
};
