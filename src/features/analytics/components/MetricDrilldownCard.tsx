import React from 'react';
import { ChevronRight } from 'lucide-react';
import { AppCard } from '../../../shared/components/AppCard';
import { SectionHeader } from '../../../shared/components/SectionHeader';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';

interface MetricItem {
  label: string;
  value: string | number;
}

interface MetricDrilldownCardProps {
  title: string;
  subtitle?: string;
  items: MetricItem[];
  onViewAll?: () => void;
}

export const MetricDrilldownCard: React.FC<MetricDrilldownCardProps> = ({
  title,
  subtitle,
  items,
  onViewAll,
}) => {
  return (
    <AppCard>
      <SectionHeader title={title} subtitle={subtitle} />

      <div className="space-y-2 mt-4">
        {items.map((item, index) => (
          <div
            key={index}
            className="flex items-center justify-between py-2 border-b last:border-b-0"
            style={{ borderColor: colors.mutedBorder }}
          >
            <span
              style={{
                fontSize: typography.small.fontSize,
                color: colors.secondaryText,
              }}
            >
              {item.label}
            </span>
            <span
              style={{
                fontSize: typography.body.fontSize,
                fontWeight: '600',
                color: colors.primaryText,
              }}
            >
              {item.value}
            </span>
          </div>
        ))}
      </div>

      {onViewAll && (
        <button
          onClick={onViewAll}
          className="flex items-center justify-center gap-1 w-full mt-4 py-2"
          style={{
            color: colors.accent,
            fontSize: typography.small.fontSize,
            fontWeight: '500',
          }}
        >
          View All
          <ChevronRight size={16} />
        </button>
      )}
    </AppCard>
  );
};
