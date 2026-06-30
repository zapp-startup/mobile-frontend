import React from 'react';
import { colors } from '../../../shared/theme/colors';
import { spacing } from '../../../shared/theme/spacing';
import { radii } from '../../../shared/theme/radii';
import { typography } from '../../../shared/theme/typography';

interface Option {
  value: string;
  label: string;
}

interface OptionButtonGridProps {
  options: Option[];
  selected: string;
  onChange: (value: string) => void;
  columns?: number;
}

export const OptionButtonGrid: React.FC<OptionButtonGridProps> = ({
  options,
  selected,
  onChange,
  columns = 2,
}) => {
  return (
    <div
      className="grid gap-3"
      style={{
        gridTemplateColumns: `repeat(${columns}, 1fr)`,
      }}
    >
      {options.map((option) => {
        const isSelected = selected === option.value;
        
        return (
          <button
            key={option.value}
            onClick={() => onChange(option.value)}
            className="py-4 px-4 transition-all active:scale-95"
            style={{
              backgroundColor: isSelected ? colors.accent : colors.elevatedSurface,
              color: isSelected ? colors.white : colors.primaryText,
              borderRadius: radii.lg,
              border: `2px solid ${isSelected ? colors.accent : colors.mutedBorder}`,
              fontSize: typography.body.fontSize,
              fontWeight: isSelected ? '600' : '400',
              boxShadow: isSelected ? `0 0 20px ${colors.accentGlow}` : 'none',
            }}
          >
            {option.label}
          </button>
        );
      })}
    </div>
  );
};
