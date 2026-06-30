import React from 'react';
import { ChevronRight, CreditCard } from 'lucide-react';
import { AppCard } from '../../../shared/components/AppCard';
import { StatusChip } from '../../../shared/components/StatusChip';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';
import { formatCurrency, formatDate } from '../../../shared/utils/formatters';
import { Subscription } from '../../../shared/utils/mockShapes';

interface SubscriptionCardProps {
  subscription: Subscription;
  onClick?: () => void;
}

export const SubscriptionCard: React.FC<SubscriptionCardProps> = ({ subscription, onClick }) => {
  const statusVariant = {
    active: 'success' as const,
    cancelled: 'error' as const,
    paused: 'warning' as const,
  }[subscription.status];

  return (
    <AppCard onClick={onClick}>
      <div className="flex items-center gap-3">
        <div
          className="p-3 rounded-lg"
          style={{ backgroundColor: `${colors.accent}20` }}
        >
          <CreditCard size={24} color={colors.accent} />
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
            {subscription.merchant}
          </h3>
          
          <div className="flex items-center gap-2 mt-1">
            <span
              style={{
                fontSize: typography.body.fontSize,
                fontWeight: '600',
                color: colors.primaryText,
              }}
            >
              {formatCurrency(subscription.amount)}
            </span>
            <span style={{ fontSize: typography.small.fontSize, color: colors.secondaryText }}>
              / {subscription.billingCycle}
            </span>
          </div>

          <div className="flex items-center gap-2 mt-1">
            <StatusChip label={subscription.status} variant={statusVariant} />
            {subscription.valueScore !== undefined && (
              <div
                className="px-2 py-1 rounded"
                style={{
                  backgroundColor: `${colors.accent}20`,
                  fontSize: typography.caption,
                  color: colors.accent,
                }}
              >
                Score: {subscription.valueScore}
              </div>
            )}
          </div>
        </div>

        <ChevronRight size={20} color={colors.secondaryText} />
      </div>
    </AppCard>
  );
};
