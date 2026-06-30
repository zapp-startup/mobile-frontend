import React from 'react';
import { LucideIcon } from 'lucide-react';
import { AppCard } from '../../../shared/components/AppCard';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';

interface KpiCardProps {
  icon: LucideIcon;
  label: string;
  value: string | number;
  subtitle?: string;
  onClick?: () => void;
}

export const KpiCard: React.FC<KpiCardProps> = ({
  icon: Icon,
  label,
  value,
  subtitle,
  onClick,
}) => {
  return (
    <AppCard onClick={onClick} className="flex-1">
      <div className="flex items-start gap-3">
        <div
          className="p-2 rounded-lg"
          style={{
            backgroundColor: `${colors.accent}20`,
          }}
        >
          <Icon size={20} color={colors.accent} />
        </div>

        <div className="flex-1 min-w-0">
          <p
            style={{
              fontSize: typography.small.fontSize,
              color: colors.secondaryText,
            }}
          >
            {label}
          </p>
          
          <p
            className="mt-1"
            style={{
              fontSize: typography.cardTitle.fontSize,
              fontWeight: typography.cardTitle.fontWeight,
              color: colors.primaryText,
            }}
          >
            {value}
          </p>
          
          {subtitle && (
            <p
              className="mt-1"
              style={{
                fontSize: typography.caption,
                color: colors.secondaryText,
              }}
            >
              {subtitle}
            </p>
          )}
        </div>
      </div>
    </AppCard>
  );
};
