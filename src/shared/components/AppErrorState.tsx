import React from 'react';
import { AlertCircle } from 'lucide-react';
import { colors } from '../theme/colors';
import { spacing } from '../theme/spacing';
import { typography } from '../theme/typography';
import { AppButton } from './AppButton';

interface AppErrorStateProps {
  title?: string;
  message: string;
  actionLabel?: string;
  onAction?: () => void;
  className?: string;
}

export const AppErrorState: React.FC<AppErrorStateProps> = ({
  title = 'Something went wrong',
  message,
  actionLabel,
  onAction,
  className = '',
}) => {
  return (
    <div className={`flex flex-col items-center justify-center py-12 px-4 text-center ${className}`}>
      <AlertCircle size={48} className="mb-4" style={{ color: colors.error }} />
      
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
      
      <p
        className="mb-6 max-w-sm"
        style={{
          fontSize: typography.body.fontSize,
          color: colors.secondaryText,
        }}
      >
        {message}
      </p>
      
      {actionLabel && onAction && (
        <AppButton onClick={onAction} variant="secondary">
          {actionLabel}
        </AppButton>
      )}
    </div>
  );
};
