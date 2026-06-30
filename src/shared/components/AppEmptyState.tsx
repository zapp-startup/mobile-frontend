import React from 'react';
import { colors } from '../theme/colors';
import { spacing } from '../theme/spacing';
import { typography } from '../theme/typography';
import { AppButton } from './AppButton';

interface AppEmptyStateProps {
  icon?: React.ReactNode;
  title: string;
  description?: string;
  actionLabel?: string;
  onAction?: () => void;
  className?: string;
}

export const AppEmptyState: React.FC<AppEmptyStateProps> = ({
  icon,
  title,
  description,
  actionLabel,
  onAction,
  className = '',
}) => {
  return (
    <div className={`flex flex-col items-center justify-center py-12 px-4 text-center ${className}`}>
      {icon && (
        <div className="mb-4" style={{ color: colors.secondaryText }}>
          {icon}
        </div>
      )}
      
      <h3
        className="mb-2"
        style={{
          fontSize: typography.cardTitle.fontSize,
          fontWeight: typography.cardTitle.fontWeight,
          color: colors.primaryText,
        }}
      >
        {title}
      </h3>
      
      {description && (
        <p
          className="mb-6 max-w-sm"
          style={{
            fontSize: typography.body.fontSize,
            color: colors.secondaryText,
          }}
        >
          {description}
        </p>
      )}
      
      {actionLabel && onAction && (
        <AppButton onClick={onAction}>
          {actionLabel}
        </AppButton>
      )}
    </div>
  );
};
