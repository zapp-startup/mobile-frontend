import React from 'react';
import { TrendingUp, TrendingDown } from 'lucide-react';
import { AppCard } from '../../../shared/components/AppCard';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';
import { ValueScoreMeter } from '../../../shared/components/ValueScoreMeter';
import { formatCurrency } from '../../../shared/utils/formatters';

interface DashboardHeroCardProps {
  totalValue: number;
  trend: number;
  valueScore: number;
}

export const DashboardHeroCard: React.FC<DashboardHeroCardProps> = ({
  totalValue,
  trend,
  valueScore,
}) => {
  const isPositive = trend >= 0;

  return (
    <AppCard glow>
      <div className="flex items-center justify-between">
        <div className="flex-1">
          <p style={{ fontSize: typography.small.fontSize, color: colors.secondaryText }}>
            Financial Health
          </p>
          
          <h2
            className="my-2"
            style={{
              fontSize: typography.stat.fontSize,
              fontWeight: typography.stat.fontWeight,
              lineHeight: typography.stat.lineHeight,
              letterSpacing: typography.stat.letterSpacing,
              color: colors.primaryText,
            }}
          >
            {formatCurrency(totalValue)}
          </h2>
          
          <div className="flex items-center gap-2">
            {isPositive ? (
              <TrendingUp size={16} color={colors.success} />
            ) : (
              <TrendingDown size={16} color={colors.error} />
            )}
            <span
              style={{
                fontSize: typography.small.fontSize,
                color: isPositive ? colors.success : colors.error,
                fontWeight: '500',
              }}
            >
              {isPositive ? '+' : ''}{trend}% this month
            </span>
          </div>
        </div>

        <ValueScoreMeter score={valueScore} size="md" showLabel={false} />
      </div>
    </AppCard>
  );
};
