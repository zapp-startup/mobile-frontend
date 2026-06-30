import React from 'react';
import { Building2, CheckCircle, AlertCircle, Loader2, ChevronRight } from 'lucide-react';
import { AppCard } from '../../../shared/components/AppCard';
import { StatusChip } from '../../../shared/components/StatusChip';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';
import { BankConnection } from '../../../shared/utils/mockShapes';
import { formatDateShort } from '../../../shared/utils/formatters';

interface BankConnectionCardProps {
  connection: BankConnection;
  onClick?: () => void;
}

export const BankConnectionCard: React.FC<BankConnectionCardProps> = ({ connection, onClick }) => {
  const statusConfig = {
    connected: { icon: CheckCircle, variant: 'success' as const, color: colors.success },
    disconnected: { icon: AlertCircle, variant: 'error' as const, color: colors.error },
    error: { icon: AlertCircle, variant: 'error' as const, color: colors.error },
    syncing: { icon: Loader2, variant: 'info' as const, color: colors.accent },
  };

  const config = statusConfig[connection.status];
  const Icon = config.icon;

  return (
    <AppCard onClick={onClick}>
      <div className="flex items-center gap-3">
        <div
          className="p-3 rounded-lg"
          style={{ backgroundColor: `${config.color}20` }}
        >
          <Building2 size={24} color={config.color} />
        </div>

        <div className="flex-1 min-w-0">
          <h3
            className="truncate"
            style={{
              fontSize: typography.cardTitle.fontSize,
              fontWeight: typography.cardTitle.fontWeight,
              color: colors.primaryText,
            }}
          >
            {connection.institutionName}
          </h3>
          
          <div className="flex items-center gap-2 mt-1">
            <StatusChip label={connection.status} variant={config.variant} />
            {connection.lastSynced && (
              <span style={{ fontSize: typography.small.fontSize, color: colors.secondaryText }}>
                • Last synced {formatDateShort(connection.lastSynced)}
              </span>
            )}
          </div>

          <p
            className="mt-1"
            style={{ fontSize: typography.small.fontSize, color: colors.secondaryText }}
          >
            {connection.accounts.length} {connection.accounts.length === 1 ? 'account' : 'accounts'} linked
          </p>
        </div>

        <ChevronRight size={20} color={colors.secondaryText} />
      </div>
    </AppCard>
  );
};
