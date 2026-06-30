import React from 'react';
import { Wallet } from 'lucide-react';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';
import { radii } from '../../../shared/theme/radii';
import { formatCurrency } from '../../../shared/utils/formatters';
import { BankAccount } from '../../../shared/utils/mockShapes';

interface LinkedAccountRowProps {
  account: BankAccount;
}

export const LinkedAccountRow: React.FC<LinkedAccountRowProps> = ({ account }) => {
  return (
    <div
      className="flex items-center gap-3 p-3"
      style={{
        backgroundColor: colors.elevatedSurface,
        borderRadius: radii.lg,
      }}
    >
      <div
        className="p-2 rounded-lg"
        style={{ backgroundColor: `${colors.accent}20` }}
      >
        <Wallet size={20} color={colors.accent} />
      </div>

      <div className="flex-1 min-w-0">
        <p
          className="truncate"
          style={{
            fontSize: typography.body.fontSize,
            fontWeight: '500',
            color: colors.primaryText,
          }}
        >
          {account.name}
        </p>
        <p
          style={{
            fontSize: typography.small.fontSize,
            color: colors.secondaryText,
          }}
        >
          {account.type} ••••{account.mask}
        </p>
      </div>

      <span
        style={{
          fontSize: typography.body.fontSize,
          fontWeight: '600',
          color: colors.primaryText,
        }}
      >
        {formatCurrency(account.balance)}
      </span>
    </div>
  );
};
