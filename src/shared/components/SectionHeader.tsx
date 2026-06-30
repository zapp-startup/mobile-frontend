import React from 'react';
import { colors } from '../theme/colors';
import { spacing } from '../theme/spacing';
import { typography } from '../theme/typography';

interface SectionHeaderProps {
  title: string;
  action?: React.ReactNode;
  subtitle?: string;
  className?: string;
}

export const SectionHeader: React.FC<SectionHeaderProps> = ({
  title,
  action,
  subtitle,
  className = '',
}) => {
  return (
    <div className={`flex items-start justify-between mb-3 ${className}`}>
      <div className="flex-1">
        <h2
          style={{
            fontSize: typography.sectionTitle.fontSize,
            fontWeight: typography.sectionTitle.fontWeight,
            lineHeight: typography.sectionTitle.lineHeight,
            color: colors.primaryText,
          }}
        >
          {title}
        </h2>
        {subtitle && (
          <p
            className="mt-1"
            style={{
              fontSize: typography.small.fontSize,
              color: colors.secondaryText,
            }}
          >
            {subtitle}
          </p>
        )}
      </div>
      
      {action && <div className="ml-4">{action}</div>}
    </div>
  );
};
