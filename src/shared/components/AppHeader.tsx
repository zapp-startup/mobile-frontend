import React from 'react';
import { useNavigate } from 'react-router';
import { ArrowLeft } from 'lucide-react';
import { colors } from '../theme/colors';
import { spacing } from '../theme/spacing';
import { typography } from '../theme/typography';

interface AppHeaderProps {
  title: string;
  showBack?: boolean;
  onBack?: () => void;
  rightActions?: React.ReactNode;
  className?: string;
}

export const AppHeader: React.FC<AppHeaderProps> = ({
  title,
  showBack = false,
  onBack,
  rightActions,
  className = '',
}) => {
  const navigate = useNavigate();

  const handleBack = () => {
    if (onBack) {
      onBack();
    } else {
      navigate(-1);
    }
  };

  return (
    <header
      className={`sticky top-0 z-40 flex items-center justify-between px-4 py-4 ${className}`}
      style={{
        backgroundColor: colors.appBackground,
        borderBottom: `1px solid ${colors.mutedBorder}`,
      }}
    >
      <div className="flex items-center gap-3 flex-1">
        {showBack && (
          <button
            onClick={handleBack}
            className="p-2 -ml-2 rounded-lg active:opacity-70 transition-opacity"
            style={{ color: colors.primaryText }}
          >
            <ArrowLeft size={20} />
          </button>
        )}
        <h1
          className="font-semibold truncate"
          style={{
            fontSize: typography.screenTitle.fontSize,
            fontWeight: typography.screenTitle.fontWeight,
            lineHeight: typography.screenTitle.lineHeight,
            color: colors.primaryText,
          }}
        >
          {title}
        </h1>
      </div>
      
      {rightActions && (
        <div className="flex items-center gap-2 ml-2">
          {rightActions}
        </div>
      )}
    </header>
  );
};
