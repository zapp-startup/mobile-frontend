import React from 'react';
import { Transaction } from '../../../shared/utils/mockShapes';
import { TransactionRow } from './TransactionRow';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';

interface TransactionGroupSectionProps {
  date: string;
  transactions: Transaction[];
  onTransactionClick: (transaction: Transaction) => void;
  onTransactionMore?: (transaction: Transaction) => void;
}

export const TransactionGroupSection: React.FC<TransactionGroupSectionProps> = ({
  date,
  transactions,
  onTransactionClick,
  onTransactionMore,
}) => {
  return (
    <div className="mb-4">
      <p
        className="mb-2 px-2"
        style={{
          fontSize: typography.small.fontSize,
          fontWeight: '600',
          color: colors.secondaryText,
        }}
      >
        {date}
      </p>
      
      <div className="space-y-2">
        {transactions.map((transaction) => (
          <TransactionRow
            key={transaction.id}
            transaction={transaction}
            onClick={() => onTransactionClick(transaction)}
            onMore={onTransactionMore ? () => onTransactionMore(transaction) : undefined}
          />
        ))}
      </div>
    </div>
  );
};
