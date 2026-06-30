import React from 'react';
import { Loader2 } from 'lucide-react';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';

export const BuyAdvisorLoadingStep: React.FC = () => {
  return (
    <div className="flex flex-col items-center justify-center py-12">
      <Loader2
        size={48}
        className="animate-spin mb-4"
        style={{ color: colors.accent }}
      />
      
      <p
        className="mb-2"
        style={{
          fontSize: typography.cardTitle.fontSize,
          fontWeight: '600',
          color: colors.primaryText,
        }}
      >
        Analyzing Purchase...
      </p>
      
      <p
        style={{
          fontSize: typography.small.fontSize,
          color: colors.secondaryText,
          textAlign: 'center',
        }}
      >
        Our AI is evaluating value, market prices, and your spending patterns
      </p>
    </div>
  );
};
