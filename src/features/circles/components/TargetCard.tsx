import React from 'react';
import { Target as TargetIcon, TrendingUp } from 'lucide-react';
import { AppCard } from '../../../shared/components/AppCard';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';
import { formatCurrency } from '../../../shared/utils/formatters';
import { Target } from '../../../shared/utils/mockShapes';

interface TargetCardProps {
  target: Target;
  onClick?: () => void;
}

export const TargetCard: React.FC<TargetCardProps> = ({ target, onClick }) => {
  return (
    <AppCard onClick={onClick}>
      <div className="flex items-start gap-3">
        <div
          className="p-2 rounded-lg"
          style={{ backgroundColor: `${colors.success}20` }}
        >
          <TargetIcon size={20} color={colors.success} />
        </div>

        <div className="flex-1 min-w-0">
          <h3
            className="truncate"
            style={{
              fontSize: typography.cardTitle.fontSize,
              fontWeight: typography.cardTitle.fontWeight,
              color: colors.primaryText,
            }}
          >
            {target.title}
          </h3>
          
          <p
            className="mt-1"
            style={{
              fontSize: typography.small.fontSize,
              color: colors.secondaryText,
            }}
          >
            {target.type} • {formatCurrency(target.currentValue)} of {formatCurrency(target.targetValue)}
          </p>

          <div className="mt-3">
            <div
              className="h-2 rounded-full"
              style={{ backgroundColor: colors.mutedBorder }}
            >
              <div
                className="h-full rounded-full transition-all"
                style={{
                  width: `${target.progress}%`,
                  backgroundColor: colors.success,
                }}
              />
            </div>
            
            <div className="flex items-center justify-between mt-1">
              <span
                style={{
                  fontSize: typography.caption,
                  color: colors.secondaryText,
                }}
              >
                {target.progress}% complete
              </span>
              
              {target.progress > 0 && (
                <div className="flex items-center gap-1">
                  <TrendingUp size={12} color={colors.success} />
                  <span
                    style={{
                      fontSize: typography.caption,
                      color: colors.success,
                    }}
                  >
                    On track
                  </span>
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    </AppCard>
  );
};
