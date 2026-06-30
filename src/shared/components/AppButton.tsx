import React from 'react';
import { colors } from '../theme/colors';
import { spacing } from '../theme/spacing';
import { radii } from '../theme/radii';
import { typography } from '../theme/typography';

interface AppButtonProps {
  children: React.ReactNode;
  variant?: 'primary' | 'secondary' | 'outline' | 'ghost' | 'danger';
  size?: 'sm' | 'md' | 'lg';
  fullWidth?: boolean;
  disabled?: boolean;
  loading?: boolean;
  onClick?: () => void;
  type?: 'button' | 'submit' | 'reset';
  className?: string;
}

export const AppButton: React.FC<AppButtonProps> = ({
  children,
  variant = 'primary',
  size = 'md',
  fullWidth = false,
  disabled = false,
  loading = false,
  onClick,
  type = 'button',
  className = '',
}) => {
  const sizeStyles = {
    sm: {
      padding: `${spacing.sm} ${spacing.md}`,
      fontSize: typography.small.fontSize,
    },
    md: {
      padding: `${spacing.md} ${spacing.lg}`,
      fontSize: typography.body.fontSize,
    },
    lg: {
      padding: `${spacing.lg} ${spacing.xl}`,
      fontSize: typography.cardTitle.fontSize,
    },
  }[size];

  const variantStyles = {
    primary: {
      backgroundColor: colors.accent,
      color: colors.white,
      border: 'none',
    },
    secondary: {
      backgroundColor: colors.elevatedSurface,
      color: colors.primaryText,
      border: `1px solid ${colors.mutedBorder}`,
    },
    outline: {
      backgroundColor: 'transparent',
      color: colors.accent,
      border: `1px solid ${colors.accent}`,
    },
    ghost: {
      backgroundColor: 'transparent',
      color: colors.primaryText,
      border: 'none',
    },
    danger: {
      backgroundColor: colors.error,
      color: colors.white,
      border: 'none',
    },
  }[variant];

  return (
    <button
      type={type}
      onClick={onClick}
      disabled={disabled || loading}
      className={`font-semibold transition-all active:scale-95 disabled:opacity-50 disabled:cursor-not-allowed ${
        fullWidth ? 'w-full' : ''
      } ${className}`}
      style={{
        ...sizeStyles,
        ...variantStyles,
        borderRadius: radii.lg,
        opacity: disabled || loading ? 0.5 : 1,
      }}
    >
      {loading ? 'Loading...' : children}
    </button>
  );
};
