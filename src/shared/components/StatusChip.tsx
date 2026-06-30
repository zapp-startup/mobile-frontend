import React from 'react';
import { colors } from '../theme/colors';
import { spacing } from '../theme/spacing';
import { radii } from '../theme/radii';
import { typography } from '../theme/typography';

interface StatusChipProps {
  label: string;
  variant?: 'success' | 'warning' | 'error' | 'neutral' | 'info';
  className?: string;
}

export const StatusChip: React.FC<StatusChipProps> = ({
  label,
  variant = 'neutral',
  className = '',
}) => {
  const variantStyles = {
    success: {
      backgroundColor: `${colors.success}20`,
      color: colors.success,
    },
    warning: {
      backgroundColor: `${colors.warning}20`,
      color: colors.warning,
    },
    error: {
      backgroundColor: `${colors.error}20`,
      color: colors.error,
    },
    neutral: {
      backgroundColor: colors.subtleSurface,
      color: colors.secondaryText,
    },
    info: {
      backgroundColor: `${colors.accent}20`,
      color: colors.accent,
    },
  }[variant];

  return (
    <span
      className={`inline-block px-2 py-1 ${className}`}
      style={{
        ...variantStyles,
        borderRadius: radii.md,
        fontSize: typography.small.fontSize,
        fontWeight: '500',
      }}
    >
      {label}
    </span>
  );
};
