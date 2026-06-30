import React from 'react';
import { colors } from '../theme/colors';
import { spacing } from '../theme/spacing';
import { radii } from '../theme/radii';
import { typography } from '../theme/typography';

interface AppSelectProps {
  label?: string;
  value: string;
  onChange: (value: string) => void;
  options: { value: string; label: string }[];
  placeholder?: string;
  error?: string;
  disabled?: boolean;
  required?: boolean;
  className?: string;
}

export const AppSelect: React.FC<AppSelectProps> = ({
  label,
  value,
  onChange,
  options,
  placeholder,
  error,
  disabled = false,
  required = false,
  className = '',
}) => {
  return (
    <div className={`flex flex-col gap-2 ${className}`}>
      {label && (
        <label
          style={{
            fontSize: typography.small.fontSize,
            fontWeight: '500',
            color: colors.primaryText,
          }}
        >
          {label} {required && <span style={{ color: colors.error }}>*</span>}
        </label>
      )}
      <select
        value={value}
        onChange={(e) => onChange(e.target.value)}
        disabled={disabled}
        className="w-full transition-all focus:outline-none focus:ring-2"
        style={{
          padding: spacing.md,
          backgroundColor: colors.subtleSurface,
          color: colors.primaryText,
          borderRadius: radii.lg,
          border: `1px solid ${error ? colors.error : colors.mutedBorder}`,
          fontSize: typography.body.fontSize,
        }}
      >
        {placeholder && <option value="">{placeholder}</option>}
        {options.map((option) => (
          <option key={option.value} value={option.value}>
            {option.label}
          </option>
        ))}
      </select>
      {error && (
        <span
          style={{
            fontSize: typography.small.fontSize,
            color: colors.error,
          }}
        >
          {error}
        </span>
      )}
    </div>
  );
};
