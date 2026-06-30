import React from 'react';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';
import { radii } from '../../../shared/theme/radii';

interface QuickActionChipProps {
  label: string;
  onClick: () => void;
}

export const QuickActionChip: React.FC<QuickActionChipProps> = ({ label, onClick }) => {
  return (
    <button
      onClick={onClick}
      className="px-3 py-2 active:opacity-70 transition-all"
      style={{
        backgroundColor: colors.elevatedSurface,
        color: colors.accent,
        borderRadius: radii.lg,
        border: `1px solid ${colors.accent}`,
        fontSize: typography.small.fontSize,
        fontWeight: '500',
      }}
    >
      {label}
    </button>
  );
};
