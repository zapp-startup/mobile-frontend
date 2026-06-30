import React from 'react';
import { CheckCircle } from 'lucide-react';
import { AppButton } from '../../../shared/components/AppButton';
import { ValueScoreMeter } from '../../../shared/components/ValueScoreMeter';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';

interface BuyAdvisorResultStepProps {
  valueScore: number;
  recommendation: string;
  insights: string[];
  onReset: () => void;
  onClose: () => void;
}

export const BuyAdvisorResultStep: React.FC<BuyAdvisorResultStepProps> = ({
  valueScore,
  recommendation,
  insights,
  onReset,
  onClose,
}) => {
  return (
    <div className="space-y-6">
      <div className="flex flex-col items-center">
        <ValueScoreMeter score={valueScore} size="lg" />
        
        <div className="flex items-center gap-2 mt-4">
          <CheckCircle size={20} color={colors.success} />
          <p
            style={{
              fontSize: typography.cardTitle.fontSize,
              fontWeight: '600',
              color: colors.success,
            }}
          >
            {recommendation}
          </p>
        </div>
      </div>

      <div>
        <p
          className="mb-3"
          style={{
            fontSize: typography.body.fontSize,
            fontWeight: '600',
            color: colors.primaryText,
          }}
        >
          Key Insights
        </p>
        
        <ul className="space-y-2">
          {insights.map((insight, index) => (
            <li
              key={index}
              style={{
                fontSize: typography.small.fontSize,
                color: colors.secondaryText,
              }}
            >
              • {insight}
            </li>
          ))}
        </ul>
      </div>

      <div className="space-y-3">
        <AppButton fullWidth onClick={onReset}>
          Analyze Another
        </AppButton>

        <AppButton variant="secondary" fullWidth onClick={onClose}>
          Close
        </AppButton>
      </div>
    </div>
  );
};
