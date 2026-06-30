import React from 'react';
import { colors } from '../theme/colors';
import { spacing } from '../theme/spacing';
import { radii } from '../theme/radii';
import { shadows } from '../theme/shadows';

interface AppCardProps {
  children: React.ReactNode;
  padding?: 'sm' | 'md' | 'lg';
  glow?: boolean;
  className?: string;
  onClick?: () => void;
}

export const AppCard: React.FC<AppCardProps> = ({
  children,
  padding = 'md',
  glow = false,
  className = '',
  onClick,
}) => {
  const paddingSize = {
    sm: spacing.sm,
    md: spacing.cardPadding,
    lg: spacing.cardPaddingLg,
  }[padding];

  return (
    <div
      className={`${onClick ? 'cursor-pointer active:opacity-90' : ''} ${className}`}
      onClick={onClick}
      style={{
        backgroundColor: colors.elevatedSurface,
        borderRadius: radii.xl,
        padding: paddingSize,
        boxShadow: glow ? shadows.glowAccent : shadows.md,
        border: `1px solid ${colors.mutedBorder}`,
      }}
    >
      {children}
    </div>
  );
};
