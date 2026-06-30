import React from 'react';
import { ChevronRight, MoreVertical } from 'lucide-react';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';
import { formatCurrency, formatDateShort } from '../../../shared/utils/formatters';
import { Transaction } from '../../../shared/utils/mockShapes';
import { radii } from '../../../shared/theme/radii';

interface TransactionRowProps {
  transaction: Transaction;
  onClick?: () => void;
  onMore?: () => void;
}

export const TransactionRow: React.FC<TransactionRowProps> = ({
  transaction,
  onClick,
  onMore,
}) => {
  return (
    <div
      className="flex items-center gap-3 p-3 active:opacity-70 transition-opacity"
      style={{
        backgroundColor: colors.elevatedSurface,
        borderRadius: radii.lg,
      }}
      onClick={onClick}
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

      <div className="flex items-center gap-2">
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
            color: transaction.type === 'income' ? colors.success : colors.primaryText,
          }}
        >
          {transaction.type === 'income' ? '+' : '-'}
          {formatCurrency(Math.abs(transaction.amount))}
        </span>

        {onMore ? (
          <button
            onClick={(e) => {
              e.stopPropagation();
              onMore();
            }}
            className="p-1"
            style={{ color: colors.secondaryText }}
          >
            <MoreVertical size={16} />
          </button>
        ) : (
          <ChevronRight size={16} color={colors.secondaryText} />
        )}
      </div>
    </div>
  );
};
