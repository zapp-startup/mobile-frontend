import React from 'react';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';

interface SubscriptionValuationSectionProps {
  explanation: string;
  confidence: number;
}

export const SubscriptionValuationSection: React.FC<SubscriptionValuationSectionProps> = ({
  explanation,
  confidence,
}) => {
  return (
    <div className="space-y-3">
      <div>
        <p
          style={{
            fontSize: typography.small.fontSize,
            fontWeight: '600',
            color: colors.primaryText,
          }}
        >
          Valuation Explanation
        </p>
        <p
          className="mt-1"
          style={{
            fontSize: typography.small.fontSize,
            color: colors.secondaryText,
            lineHeight: '1.5',
          }}
        >
          {explanation}
        </p>
      </div>

      <div>
        <p
          style={{
            fontSize: typography.small.fontSize,
            fontWeight: '600',
            color: colors.primaryText,
          }}
        >
          Confidence Level
        </p>
        <div className="flex items-center gap-2 mt-2">
          <div
            className="flex-1 h-2 rounded-full"
            style={{ backgroundColor: colors.mutedBorder }}
          >
            <div
              className="h-full rounded-full transition-all"
              style={{
                width: `${confidence}%`,
                backgroundColor: colors.accent,
              }}
            />
          </div>
          <span
            style={{
              fontSize: typography.body.fontSize,
              fontWeight: '600',
              color: colors.accent,
            }}
          >
            {confidence}%
          </span>
        </div>
      </div>
    </div>
  );
};
