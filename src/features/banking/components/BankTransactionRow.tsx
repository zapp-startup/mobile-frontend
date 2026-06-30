import React from 'react';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';
import { radii } from '../../../shared/theme/radii';
import { formatCurrency, formatDateShort } from '../../../shared/utils/formatters';
import { BankTransaction } from '../../../shared/utils/mockShapes';

interface BankTransactionRowProps {
  transaction: BankTransaction;
}

export const BankTransactionRow: React.FC<BankTransactionRowProps> = ({ transaction }) => {
  return (
    <div
      className="flex items-center justify-between p-3"
      style={{
        backgroundColor: colors.elevatedSurface,
        borderRadius: radii.lg,
      }}
    >
      <div className="flex-1 min-w-0">
        <p
          className="truncate"
          style={{
            fontSize: typography.body.fontSize,
            fontWeight: '500',
            color: colors.primaryText,
          }}
        >
          {transaction.merchant}
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

      <div className="flex items-center gap-2 ml-3">
        {transaction.valueScore !== undefined && (
          <div
            className="px-2 py-1 rounded"
            style={{
              backgroundColor: `${colors.accent}20`,
              fontSize: typography.caption,
              color: colors.accent,
            }}
          >
            {transaction.valueScore}
          </div>
        )}

        <span
          style={{
            fontSize: typography.body.fontSize,
            fontWeight: '600',
            color: transaction.type === 'credit' ? colors.success : colors.primaryText,
          }}
        >
          {transaction.type === 'credit' ? '+' : '-'}{formatCurrency(Math.abs(transaction.amount))}
        </span>
      </div>
    </div>
  );
};
