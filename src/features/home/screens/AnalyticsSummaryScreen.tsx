import React from 'react';
import { useNavigate } from 'react-router';
import { AppScreen } from '../../../shared/components/AppScreen';
import { AppHeader } from '../../../shared/components/AppHeader';
import { AppCard } from '../../../shared/components/AppCard';
import { AppButton } from '../../../shared/components/AppButton';
import { SectionHeader } from '../../../shared/components/SectionHeader';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';

export const AnalyticsSummaryScreen: React.FC = () => {
  const navigate = useNavigate();

  return (
    <AppScreen>
      <AppHeader title="Analytics Summary" showBack />

      <div className="px-4 py-6 space-y-4">
        <AppCard>
          <SectionHeader title="Quick Stats" />
          <div className="grid grid-cols-2 gap-4 mt-4">
            <div>
              <p style={{ fontSize: typography.small.fontSize, color: colors.secondaryText }}>
                Total Tracked
              </p>
              <p
                className="mt-1"
                style={{
                  fontSize: typography.cardTitle.fontSize,
                  fontWeight: '700',
                  color: colors.primaryText,
                }}
              >
                $12,450
              </p>
            </div>
            <div>
              <p style={{ fontSize: typography.small.fontSize, color: colors.secondaryText }}>
                This Month
              </p>
              <p
                className="mt-1"
                style={{
                  fontSize: typography.cardTitle.fontSize,
                  fontWeight: '700',
                  color: colors.success,
                }}
              >
                +8.3%
              </p>
            </div>
          </div>
        </AppCard>

        <AppCard>
          <SectionHeader title="Tracked Stacks" subtitle="Your subscription bundles" />
          <p style={{ fontSize: typography.small.fontSize, color: colors.secondaryText }}>
            3 active stacks
          </p>
        </AppCard>

        <AppCard>
          <SectionHeader title="Highest Overlap" subtitle="Redundant services detected" />
          <p style={{ fontSize: typography.small.fontSize, color: colors.secondaryText }}>
            2 streaming services with similar content
          </p>
        </AppCard>

        <AppCard>
          <SectionHeader title="Watchlist" subtitle="Items you're tracking" />
          <p style={{ fontSize: typography.small.fontSize, color: colors.secondaryText }}>
            5 items on watchlist
          </p>
        </AppCard>

        <AppButton fullWidth onClick={() => navigate('/analytics')}>
          View Full Analytics
        </AppButton>
      </div>
    </AppScreen>
  );
};
