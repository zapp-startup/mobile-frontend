import React from 'react';
import { useParams, useNavigate } from 'react-router';
import { Edit2, Trash2 } from 'lucide-react';
import { AppScreen } from '../../../shared/components/AppScreen';
import { AppHeader } from '../../../shared/components/AppHeader';
import { AppCard } from '../../../shared/components/AppCard';
import { AppButton } from '../../../shared/components/AppButton';
import { SectionHeader } from '../../../shared/components/SectionHeader';
import { SubscriptionValueCard } from '../components/SubscriptionValueCard';
import { SubscriptionValuationSection } from '../components/SubscriptionValuationSection';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';
import { formatCurrency, formatDate } from '../../../shared/utils/formatters';

export const SubscriptionDetailScreen: React.FC = () => {
  const { id } = useParams();
  const navigate = useNavigate();

  const subscription = {
    id,
    merchant: 'Netflix',
    amount: 15.99,
    billingCycle: 'monthly',
    startedDate: '2023-01-15',
    status: 'active',
    notes: 'Standard plan with HD streaming',
    valueScore: 85,
    valuation: {
      explanation: 'High value based on frequent usage (20+ hours/month) and content variety. Your usage patterns indicate strong engagement with original content and recommendations.',
      confidence: 92,
    },
  };

  return (
    <AppScreen>
      <AppHeader title="Subscription Details" showBack />

      <div className="px-4 py-6 space-y-4">
        <AppCard>
          <SectionHeader title={subscription.merchant} />

          <div className="space-y-3 mt-4">
            <div className="flex justify-between py-2 border-b" style={{ borderColor: colors.mutedBorder }}>
              <span style={{ color: colors.secondaryText }}>Amount</span>
              <span
                style={{
                  fontSize: typography.cardTitle.fontSize,
                  fontWeight: '700',
                  color: colors.primaryText,
                }}
              >
                {formatCurrency(subscription.amount)}
              </span>
            </div>

            <div className="flex justify-between py-2 border-b" style={{ borderColor: colors.mutedBorder }}>
              <span style={{ color: colors.secondaryText }}>Billing Cycle</span>
              <span style={{ color: colors.primaryText }}>{subscription.billingCycle}</span>
            </div>

            <div className="flex justify-between py-2 border-b" style={{ borderColor: colors.mutedBorder }}>
              <span style={{ color: colors.secondaryText }}>Started</span>
              <span style={{ color: colors.primaryText }}>{formatDate(subscription.startedDate)}</span>
            </div>

            <div className="flex justify-between py-2 border-b" style={{ borderColor: colors.mutedBorder }}>
              <span style={{ color: colors.secondaryText }}>Status</span>
              <span style={{ color: colors.success }}>{subscription.status}</span>
            </div>

            {subscription.notes && (
              <div className="py-2">
                <span style={{ color: colors.secondaryText, display: 'block', marginBottom: '0.5rem' }}>
                  Notes
                </span>
                <p style={{ color: colors.primaryText }}>{subscription.notes}</p>
              </div>
            )}
          </div>
        </AppCard>

        <SubscriptionValueCard
          valueScore={subscription.valueScore}
          valuation={subscription.valuation}
        />

        {subscription.valuation && (
          <AppCard>
            <SubscriptionValuationSection
              explanation={subscription.valuation.explanation}
              confidence={subscription.valuation.confidence}
            />
          </AppCard>
        )}

        <div className="grid grid-cols-2 gap-3">
          <AppButton
            variant="secondary"
            onClick={() => navigate(`/subscriptions/${id}/edit`)}
          >
            <Edit2 size={16} className="inline mr-2" />
            Edit
          </AppButton>
          <AppButton variant="danger">
            <Trash2 size={16} className="inline mr-2" />
            Delete
          </AppButton>
        </div>
      </div>
    </AppScreen>
  );
};
