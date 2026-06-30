import React from 'react';
import { AppCard } from '../../../shared/components/AppCard';
import { SectionHeader } from '../../../shared/components/SectionHeader';
import { ValueScoreMeter } from '../../../shared/components/ValueScoreMeter';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';

interface ValueScoreBreakdownCardProps {
  score: number;
  factors: Array<{
    name: string;
    score: number;
    weight: number;
  }>;
}

export const ValueScoreBreakdownCard: React.FC<ValueScoreBreakdownCardProps> = ({
  score,
  factors,
}) => {
  return (
    <AppCard>
      <SectionHeader title="Value Score Breakdown" />

      <div className="flex justify-center my-6">
        <ValueScoreMeter score={score} size="lg" />
      </div>

      <div className="space-y-3">
        {factors.map((factor, index) => (
          <div key={index}>
            <div className="flex items-center justify-between mb-1">
              <span style={{ fontSize: typography.small.fontSize, color: colors.primaryText }}>
                {factor.name}
              </span>
              <span
                style={{
                  fontSize: typography.small.fontSize,
                  fontWeight: '600',
                  color: colors.accent,
                }}
              >
                {factor.score}/100
              </span>
            </div>
            
            <div
              className="h-1.5 rounded-full"
              style={{ backgroundColor: colors.mutedBorder }}
            >
              <div
                className="h-full rounded-full transition-all"
                style={{
                  width: `${factor.score}%`,
                  backgroundColor: colors.accent,
                }}
              />
            </div>
            
            <p
              className="mt-1"
              style={{ fontSize: typography.caption, color: colors.secondaryText }}
            >
              Weight: {factor.weight}%
            </p>
          </div>
        ))}
      </div>
    </AppCard>
  );
};
