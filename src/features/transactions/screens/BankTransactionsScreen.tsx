import React from 'react';
import { useParams } from 'react-router';
import { AppScreen } from '../../../shared/components/AppScreen';
import { AppHeader } from '../../../shared/components/AppHeader';
import { BankTransactionRow } from '../../banking/components/BankTransactionRow';
import { SectionHeader } from '../../../shared/components/SectionHeader';

export const BankTransactionsScreen: React.FC = () => {
  const { id } = useParams();

  // Mock data
  const transactions = [
    { id: '1', merchant: 'Whole Foods', amount: -67.42, category: 'Groceries', date: '2026-04-15', type: 'debit' as const, valueScore: 78 },
    { id: '2', merchant: 'Salary Deposit', amount: 5000, category: 'Income', date: '2026-04-14', type: 'credit' as const },
    { id: '3', merchant: 'Netflix', amount: -15.99, category: 'Subscriptions', date: '2026-04-13', type: 'debit' as const, valueScore: 85 },
    { id: '4', merchant: 'Uber', amount: -23.15, category: 'Transportation', date: '2026-04-12', type: 'debit' as const, valueScore: 65 },
  ];

  return (
    <AppScreen>
      <AppHeader title="Bank Transactions" showBack />

      <div className="px-4 py-6 space-y-4">
        <SectionHeader title="All Transactions" subtitle={`${transactions.length} transactions`} />
        
        <div className="space-y-2">
          {transactions.map((transaction) => (
            <BankTransactionRow key={transaction.id} transaction={transaction} />
          ))}
        </div>
      </div>
    </AppScreen>
  );
};
