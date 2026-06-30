import React from 'react';
import { LucideIcon, ChevronRight } from 'lucide-react';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';
import { radii } from '../../../shared/theme/radii';

interface SettingsRowProps {
  icon: LucideIcon;
  label: string;
  onClick: () => void;
  variant?: 'default' | 'danger';
}

export const SettingsRow: React.FC<SettingsRowProps> = ({
  icon: Icon,
  label,
  onClick,
  variant = 'default',
}) => {
  const textColor = variant === 'danger' ? colors.error : colors.primaryText;

  return (
    <button
      onClick={onClick}
      className="w-full flex items-center gap-3 p-3 active:opacity-70 transition-opacity"
      style={{
        backgroundColor: colors.elevatedSurface,
        borderRadius: radii.lg,
      }}
    >
      <Icon size={20} color={textColor} />
      
      <span
        className="flex-1 text-left"
        style={{
          fontSize: typography.body.fontSize,
          fontWeight: '500',
          color: textColor,
        }}
      >
        {label}
      </span>

      <ChevronRight size={20} color={colors.secondaryText} />
    </button>
  );
};
