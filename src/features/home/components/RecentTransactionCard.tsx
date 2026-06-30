import React from 'react';
import { ChevronRight } from 'lucide-react';
import { AppCard } from '../../../shared/components/AppCard';
import { SectionHeader } from '../../../shared/components/SectionHeader';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';
import { formatCurrency, formatDateShort } from '../../../shared/utils/formatters';
import { Transaction } from '../../../shared/utils/mockShapes';

interface RecentTransactionCardProps {
  transactions: Transaction[];
  onViewAll?: () => void;
}

export const RecentTransactionCard: React.FC<RecentTransactionCardProps> = ({
  transactions,
  onViewAll,
}) => {
  return (
    <AppCard>
      <SectionHeader title="Recent Transactions" />

      <div className="space-y-3">
        {transactions.map((transaction) => (
          <div
            key={transaction.id}
            className="flex items-center justify-between py-2 border-b last:border-b-0"
            style={{ borderColor: colors.mutedBorder }}
          >
            <div className="flex-1 min-w-0">
              <p
                className="truncate"
                style={{
                  fontSize: typography.body.fontSize,
                  color: colors.primaryText,
                  fontWeight: '500',
                }}
              >
                {transaction.description}
              </p>
              <p
                style={{
                  fontSize: typography.small.fontSize,
                  color: colors.secondaryText,
                }}
              >
                {transaction.category} • {formatDateShort(transaction.date)}
              </p>
            </div>

            <span
              className="ml-3"
              style={{
                fontSize: typography.body.fontSize,
                fontWeight: '600',
                color: transaction.type === 'income' ? colors.success : colors.primaryText,
              }}
            >
              {transaction.type === 'income' ? '+' : '-'}{formatCurrency(Math.abs(transaction.amount))}
            </span>
          </div>
        ))}
      </div>

      {onViewAll && (
        <button
          onClick={onViewAll}
          className="flex items-center justify-center gap-1 w-full mt-4 py-2"
          style={{ color: colors.accent, fontSize: typography.small.fontSize, fontWeight: '500' }}
        >
          See All
          <ChevronRight size={16} />
        </button>
      )}
    </AppCard>
  );
};
