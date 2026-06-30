import React from 'react';
import { Sparkles } from 'lucide-react';
import { AppCard } from '../../../shared/components/AppCard';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';

interface InsightCardProps {
  title: string;
  description: string;
  actionLabel?: string;
  onAction?: () => void;
}

export const InsightCard: React.FC<InsightCardProps> = ({
  title,
  description,
  actionLabel,
  onAction,
}) => {
  return (
    <AppCard>
      <div className="flex gap-3">
        <div
          className="p-2 rounded-lg h-fit"
          style={{ backgroundColor: `${colors.accent}20` }}
        >
          <Sparkles size={20} color={colors.accent} />
        </div>

        <div className="flex-1">
          <h3
            style={{
              fontSize: typography.cardTitle.fontSize,
              fontWeight: typography.cardTitle.fontWeight,
              color: colors.primaryText,
              marginBottom: '0.5rem',
            }}
          >
            {title}
          </h3>
          
          <p
            style={{
              fontSize: typography.small.fontSize,
              color: colors.secondaryText,
              marginBottom: actionLabel ? '1rem' : '0',
            }}
          >
            {description}
          </p>

          {actionLabel && onAction && (
            <button
              onClick={onAction}
              style={{
                color: colors.accent,
                fontSize: typography.small.fontSize,
                fontWeight: '500',
              }}
            >
              {actionLabel} →
            </button>
          )}
        </div>
      </div>
    </AppCard>
  );
};
