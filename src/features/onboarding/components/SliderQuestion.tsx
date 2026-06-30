import React from 'react';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';

interface SliderQuestionProps {
  value: number;
  onChange: (value: number) => void;
  min: number;
  max: number;
  step?: number;
  labels?: { min: string; max: string };
}

export const SliderQuestion: React.FC<SliderQuestionProps> = ({
  value,
  onChange,
  min,
  max,
  step = 1,
  labels,
}) => {
  return (
    <div>
      <input
        type="range"
        min={min}
        max={max}
        step={step}
        value={value}
        onChange={(e) => onChange(Number(e.target.value))}
        className="w-full h-2 rounded-full appearance-none cursor-pointer"
        style={{
          background: `linear-gradient(to right, ${colors.accent} 0%, ${colors.accent} ${((value - min) / (max - min)) * 100}%, ${colors.mutedBorder} ${((value - min) / (max - min)) * 100}%, ${colors.mutedBorder} 100%)`,
        }}
      />

      <div className="flex justify-center mt-4">
        <span
          style={{
            fontSize: typography.cardTitle.fontSize,
            fontWeight: '600',
            color: colors.accent,
          }}
        >
          {value}
        </span>
      </div>

      {labels && (
        <div className="flex justify-between mt-2">
          <span style={{ fontSize: typography.small.fontSize, color: colors.secondaryText }}>
            {labels.min}
          </span>
          <span style={{ fontSize: typography.small.fontSize, color: colors.secondaryText }}>
            {labels.max}
          </span>
        </div>
      )}
    </div>
  );
};
