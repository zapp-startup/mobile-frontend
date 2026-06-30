import React from 'react';
import { colors } from '../theme/colors';
import { spacing } from '../theme/spacing';

interface AppScreenProps {
  children: React.ReactNode;
  padding?: boolean;
  className?: string;
}

export const AppScreen: React.FC<AppScreenProps> = ({ 
  children, 
  padding = true,
  className = '' 
}) => {
  return (
    <div
      className={`min-h-screen ${className}`}
      style={{
        backgroundColor: colors.appBackground,
        color: colors.primaryText,
        paddingBottom: padding ? '5rem' : '0', // Account for tab bar
      }}
    >
      {children}
    </div>
  );
};
