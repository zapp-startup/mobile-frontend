import React from 'react';
import { LucideIcon } from 'lucide-react';
import { AppCard } from '../../../shared/components/AppCard';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';

interface AnalyticsMetricCardProps {
  icon: LucideIcon;
  title: string;
  value: string | number;
  subtitle?: string;
  trend?: number;
}

export const AnalyticsMetricCard: React.FC<AnalyticsMetricCardProps> = ({
  icon: Icon,
  title,
  value,
  subtitle,
  trend,
}) => {
  return (
    <AppCard>
      <div className="flex items-start gap-3">
        <div
          className="p-2 rounded-lg"
          style={{ backgroundColor: `${colors.accent}20` }}
        >
          <Icon size={20} color={colors.accent} />
        </div>

        <div className="flex-1">
          <p
            style={{
              fontSize: typography.small.fontSize,
              color: colors.secondaryText,
            }}
          >
            {title}
          </p>
          
          <p
            className="mt-1"
            style={{
              fontSize: typography.cardTitle.fontSize,
              fontWeight: '700',
              color: colors.primaryText,
            }}
          >
            {value}
          </p>

          {subtitle && (
            <p
              className="mt-1"
              style={{
                fontSize: typography.small.fontSize,
                color: colors.secondaryText,
              }}
            >
              {subtitle}
            </p>
          )}

          {trend !== undefined && (
            <p
              className="mt-1"
              style={{
                fontSize: typography.small.fontSize,
                fontWeight: '500',
                color: trend >= 0 ? colors.success : colors.error,
              }}
            >
              {trend >= 0 ? '+' : ''}{trend}% vs last month
            </p>
          )}
        </div>
      </div>
    </AppCard>
  );
};
