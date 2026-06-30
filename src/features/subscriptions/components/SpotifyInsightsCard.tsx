import React from 'react';
import { Headphones, TrendingUp } from 'lucide-react';
import { AppCard } from '../../../shared/components/AppCard';
import { SectionHeader } from '../../../shared/components/SectionHeader';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';

interface SpotifyInsightsCardProps {
  insights: {
    monthlyListeningHours: number;
    topGenre: string;
  };
}

export const SpotifyInsightsCard: React.FC<SpotifyInsightsCardProps> = ({ insights }) => {
  return (
    <AppCard>
      <SectionHeader title="Spotify Insights" />

      <div className="grid grid-cols-2 gap-4 mt-4">
        <div className="flex items-start gap-2">
          <div
            className="p-2 rounded-lg"
            style={{ backgroundColor: `${colors.accent}20` }}
          >
            <Headphones size={16} color={colors.accent} />
          </div>
          <div>
            <p
              style={{
                fontSize: typography.small.fontSize,
                color: colors.secondaryText,
              }}
            >
              Monthly Hours
            </p>
            <p
              className="mt-1"
              style={{
                fontSize: typography.cardTitle.fontSize,
                fontWeight: '700',
                color: colors.primaryText,
              }}
            >
              {insights.monthlyListeningHours}
            </p>
          </div>
        </div>

        <div className="flex items-start gap-2">
          <div
            className="p-2 rounded-lg"
            style={{ backgroundColor: `${colors.success}20` }}
          >
            <TrendingUp size={16} color={colors.success} />
          </div>
          <div>
            <p
              style={{
                fontSize: typography.small.fontSize,
                color: colors.secondaryText,
              }}
            >
              Top Genre
            </p>
            <p
              className="mt-1"
              style={{
                fontSize: typography.body.fontSize,
                fontWeight: '600',
                color: colors.primaryText,
              }}
            >
              {insights.topGenre}
            </p>
          </div>
        </div>
      </div>
    </AppCard>
  );
};
