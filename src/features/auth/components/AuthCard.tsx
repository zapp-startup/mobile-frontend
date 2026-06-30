import React from 'react';
import { colors } from '../../../shared/theme/colors';
import { spacing } from '../../../shared/theme/spacing';
import { radii } from '../../../shared/theme/radii';
import { typography } from '../../../shared/theme/typography';

interface AuthCardProps {
  children: React.ReactNode;
  title: string;
  subtitle?: string;
}

export const AuthCard: React.FC<AuthCardProps> = ({ children, title, subtitle }) => {
  return (
    <div className="w-full max-w-md mx-auto px-4">
      <div
        className="p-6"
        style={{
          backgroundColor: colors.elevatedSurface,
          borderRadius: radii.xl,
          border: `1px solid ${colors.mutedBorder}`,
        }}
      >
        <h1
          className="mb-2"
          style={{
            fontSize: typography.displayTitle.fontSize,
            fontWeight: typography.displayTitle.fontWeight,
            color: colors.primaryText,
            textAlign: 'center',
          }}
        >
          {title}
        </h1>
        
        {subtitle && (
          <p
            className="mb-6"
            style={{
              fontSize: typography.body.fontSize,
              color: colors.secondaryText,
              textAlign: 'center',
            }}
          >
            {subtitle}
          </p>
        )}
        
        {children}
      </div>
    </div>
  );
};
