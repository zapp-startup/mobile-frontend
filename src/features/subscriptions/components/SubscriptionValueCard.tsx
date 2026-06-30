import React from 'react';
import { AppCard } from '../../../shared/components/AppCard';
import { SectionHeader } from '../../../shared/components/SectionHeader';
import { ValueScoreMeter } from '../../../shared/components/ValueScoreMeter';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';

interface SubscriptionValueCardProps {
  valueScore?: number;
  valuation?: {
    explanation: string;
    confidence: number;
  };
}

export const SubscriptionValueCard: React.FC<SubscriptionValueCardProps> = ({
  valueScore,
  valuation,
}) => {
  if (!valueScore && !valuation) return null;

  return (
    <AppCard>
      <SectionHeader title="Value Assessment" />

      {valueScore && (
        <div className="flex justify-center my-4">
          <ValueScoreMeter score={valueScore} size="md" />
        </div>
      )}

      {valuation && (
        <div className="space-y-3">
          <div>
            <p
              style={{
                fontSize: typography.small.fontSize,
                fontWeight: '500',
                color: colors.primaryText,
              }}
            >
              Analysis
            </p>
            <p
              className="mt-1"
              style={{
                fontSize: typography.small.fontSize,
                color: colors.secondaryText,
              }}
            >
              {valuation.explanation}
            </p>
          </div>

          <div>
            <p
              style={{
                fontSize: typography.small.fontSize,
                fontWeight: '500',
                color: colors.primaryText,
              }}
            >
              Confidence
            </p>
            <div className="flex items-center gap-2 mt-1">
              <div
                className="flex-1 h-2 rounded-full"
                style={{ backgroundColor: colors.mutedBorder }}
              >
                <div
                  className="h-full rounded-full transition-all"
                  style={{
                    width: `${valuation.confidence}%`,
                    backgroundColor: colors.accent,
                  }}
                />
              </div>
              <span
                style={{
                  fontSize: typography.small.fontSize,
                  fontWeight: '600',
                  color: colors.accent,
                }}
              >
                {valuation.confidence}%
              </span>
            </div>
          </div>
        </div>
      )}
    </AppCard>
  );
};
