import React from 'react';
import { Loader2 } from 'lucide-react';
import { colors } from '../theme/colors';
import { typography } from '../theme/typography';

interface AppLoadingStateProps {
  message?: string;
  className?: string;
}

export const AppLoadingState: React.FC<AppLoadingStateProps> = ({
  message = 'Loading...',
  className = '',
}) => {
  return (
    <div className={`flex flex-col items-center justify-center py-12 px-4 ${className}`}>
      <Loader2 
        size={32} 
        className="animate-spin mb-3" 
        style={{ color: colors.accent }} 
      />
      <p
        style={{
          fontSize: typography.body.fontSize,
          color: colors.secondaryText,
        }}
      >
        {message}
      </p>
    </div>
  );
};
