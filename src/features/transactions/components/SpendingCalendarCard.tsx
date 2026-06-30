import React from 'react';
import { AppCard } from '../../../shared/components/AppCard';
import { SectionHeader } from '../../../shared/components/SectionHeader';
import { colors } from '../../../shared/theme/colors';
import { radii } from '../../../shared/theme/radii';

interface SpendingCalendarCardProps {
  data: Array<{ date: string; amount: number }>;
}

export const SpendingCalendarCard: React.FC<SpendingCalendarCardProps> = ({ data }) => {
  const maxAmount = Math.max(...data.map((d) => d.amount));

  return (
    <AppCard>
      <SectionHeader title="Spending Heatmap" subtitle="Daily spending over the last 30 days" />

      <div className="grid grid-cols-7 gap-1 mt-4">
        {data.map((day, index) => {
          const intensity = maxAmount > 0 ? day.amount / maxAmount : 0;
          const opacity = 0.1 + intensity * 0.9;

          return (
            <div
              key={index}
              className="aspect-square"
              style={{
                backgroundColor: colors.accent,
                opacity,
                borderRadius: radii.sm,
              }}
              title={`$${day.amount.toFixed(2)}`}
            />
          );
        })}
      </div>

      <div className="flex items-center justify-between mt-4">
        <span style={{ fontSize: '0.75rem', color: colors.secondaryText }}>
          Less
        </span>
        <div className="flex gap-1">
          {[0.2, 0.4, 0.6, 0.8, 1.0].map((opacity, index) => (
            <div
              key={index}
              className="w-4 h-4"
              style={{
                backgroundColor: colors.accent,
                opacity,
                borderRadius: radii.sm,
              }}
            />
          ))}
        </div>
        <span style={{ fontSize: '0.75rem', color: colors.secondaryText }}>
          More
        </span>
      </div>
    </AppCard>
  );
};
