import React from 'react';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';
import { radii } from '../../../shared/theme/radii';
import { formatCurrency, formatNumber } from '../../../shared/utils/formatters';

interface TransactionMetricRowProps {
  totalCount: number;
  totalSpent: number;
  totalIncome: number;
  netAmount: number;
}

export const TransactionMetricRow: React.FC<TransactionMetricRowProps> = ({
  totalCount,
  totalSpent,
  totalIncome,
  netAmount,
}) => {
  return (
    <div
      className="grid grid-cols-2 gap-3 p-4"
      style={{
        backgroundColor: colors.elevatedSurface,
        borderRadius: radii.lg,
      }}
    >
      <div>
        <p style={{ fontSize: typography.caption, color: colors.secondaryText }}>
          Transactions
        </p>
        <p
          className="mt-1"
          style={{
            fontSize: typography.body.fontSize,
            fontWeight: '600',
            color: colors.primaryText,
          }}
        >
          {formatNumber(totalCount)}
        </p>
      </div>

      <div>
        <p style={{ fontSize: typography.caption, color: colors.secondaryText }}>
          Spent
        </p>
        <p
          className="mt-1"
          style={{
            fontSize: typography.body.fontSize,
            fontWeight: '600',
            color: colors.error,
          }}
        >
          {formatCurrency(totalSpent)}
        </p>
      </div>

      <div>
        <p style={{ fontSize: typography.caption, color: colors.secondaryText }}>
          Income
        </p>
        <p
          className="mt-1"
          style={{
            fontSize: typography.body.fontSize,
            fontWeight: '600',
            color: colors.success,
          }}
        >
          {formatCurrency(totalIncome)}
        </p>
      </div>

      <div>
        <p style={{ fontSize: typography.caption, color: colors.secondaryText }}>
          Net
        </p>
        <p
          className="mt-1"
          style={{
            fontSize: typography.body.fontSize,
            fontWeight: '600',
            color: netAmount >= 0 ? colors.success : colors.error,
          }}
        >
          {formatCurrency(netAmount)}
        </p>
      </div>
    </div>
  );
};
