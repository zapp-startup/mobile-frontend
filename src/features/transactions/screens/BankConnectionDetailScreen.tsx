import React, { useState } from 'react';
import { useParams, useNavigate } from 'react-router';
import { RefreshCw, Unlink } from 'lucide-react';
import { AppScreen } from '../../../shared/components/AppScreen';
import { AppHeader } from '../../../shared/components/AppHeader';
import { AppCard } from '../../../shared/components/AppCard';
import { AppButton } from '../../../shared/components/AppButton';
import { SectionHeader } from '../../../shared/components/SectionHeader';
import { LinkedAccountRow } from '../../banking/components/LinkedAccountRow';
import { BankTransactionRow } from '../../banking/components/BankTransactionRow';
import { StatusChip } from '../../../shared/components/StatusChip';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';
import { formatDateShort } from '../../../shared/utils/formatters';

export const BankConnectionDetailScreen: React.FC = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const [isSyncing, setIsSyncing] = useState(false);

  // Mock data
  const connection = {
    id,
    institutionName: 'Chase Bank',
    status: 'connected',
    lastSynced: '2026-04-15',
    accounts: [
      { id: '1', name: 'Checking', type: 'checking', mask: '1234', balance: 2450.75 },
      { id: '2', name: 'Savings', type: 'savings', mask: '5678', balance: 10000.00 },
    ],
  };

  const recentTransactions = [
    { id: '1', merchant: 'Whole Foods', amount: -67.42, category: 'Groceries', date: '2026-04-15', type: 'debit' as const, valueScore: 78 },
    { id: '2', merchant: 'Salary Deposit', amount: 5000, category: 'Income', date: '2026-04-14', type: 'credit' as const },
  ];

  const handleSync = () => {
    setIsSyncing(true);
    setTimeout(() => setIsSyncing(false), 2000);
  };

  return (
    <AppScreen>
      <AppHeader title={connection.institutionName} showBack />

      <div className="px-4 py-6 space-y-4">
        <AppCard>
          <div className="flex items-center justify-between mb-4">
            <div>
              <p style={{ fontSize: typography.small.fontSize, color: colors.secondaryText }}>
                Status
              </p>
              <StatusChip label={connection.status} variant="success" className="mt-1" />
            </div>
            
            <div className="text-right">
              <p style={{ fontSize: typography.small.fontSize, color: colors.secondaryText }}>
                Last Synced
              </p>
              <p
                className="mt-1"
                style={{
                  fontSize: typography.body.fontSize,
                  fontWeight: '500',
                  color: colors.primaryText,
                }}
              >
                {formatDateShort(connection.lastSynced)}
              </p>
            </div>
          </div>

          <AppButton
            variant="secondary"
            fullWidth
            onClick={handleSync}
            loading={isSyncing}
          >
            <RefreshCw size={16} className="inline mr-2" />
            Sync Now
          </AppButton>
        </AppCard>

        <div>
          <SectionHeader title="Linked Accounts" subtitle={`${connection.accounts.length} accounts`} />
          <div className="space-y-2">
            {connection.accounts.map((account) => (
              <LinkedAccountRow key={account.id} account={account} />
            ))}
          </div>
        </div>

        <div>
          <SectionHeader
            title="Recent Transactions"
            action={
              <button
                onClick={() => navigate(`/transactions/banking/${id}/transactions`)}
                style={{ color: colors.accent, fontSize: typography.small.fontSize, fontWeight: '500' }}
              >
                See All
              </button>
            }
          />
          <div className="space-y-2">
            {recentTransactions.map((transaction) => (
              <BankTransactionRow key={transaction.id} transaction={transaction} />
            ))}
          </div>
        </div>

        <AppButton variant="danger" fullWidth>
          <Unlink size={16} className="inline mr-2" />
          Disconnect Bank
        </AppButton>
      </div>
    </AppScreen>
  );
};
