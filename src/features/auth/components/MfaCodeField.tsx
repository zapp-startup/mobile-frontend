import React, { useState, useRef, useEffect } from 'react';
import { colors } from '../../../shared/theme/colors';
import { spacing } from '../../../shared/theme/spacing';
import { radii } from '../../../shared/theme/radii';
import { typography } from '../../../shared/theme/typography';

interface MfaCodeFieldProps {
  length?: number;
  value: string;
  onChange: (value: string) => void;
  error?: boolean;
}

export const MfaCodeField: React.FC<MfaCodeFieldProps> = ({
  length = 6,
  value,
  onChange,
  error = false,
}) => {
  const inputRefs = useRef<(HTMLInputElement | null)[]>([]);

  const handleChange = (index: number, digit: string) => {
    if (!/^\d*$/.test(digit)) return;

    const newValue = value.split('');
    newValue[index] = digit;
    onChange(newValue.join(''));

    if (digit && index < length - 1) {
      inputRefs.current[index + 1]?.focus();
    }
  };

  const handleKeyDown = (index: number, e: React.KeyboardEvent) => {
    if (e.key === 'Backspace' && !value[index] && index > 0) {
      inputRefs.current[index - 1]?.focus();
    }
  };

  const handlePaste = (e: React.ClipboardEvent) => {
    e.preventDefault();
    const paste = e.clipboardData.getData('text').replace(/\D/g, '').slice(0, length);
    onChange(paste);
  };

  return (
    <div className="flex gap-2 justify-center">
      {Array.from({ length }).map((_, index) => (
        <input
          key={index}
          ref={(el) => (inputRefs.current[index] = el)}
          type="text"
          inputMode="numeric"
          maxLength={1}
          value={value[index] || ''}
          onChange={(e) => handleChange(index, e.target.value)}
          onKeyDown={(e) => handleKeyDown(index, e)}
          onPaste={handlePaste}
          className="text-center focus:outline-none focus:ring-2 transition-all"
          style={{
            width: '3rem',
            height: '3.5rem',
            backgroundColor: colors.subtleSurface,
            color: colors.primaryText,
            borderRadius: radii.lg,
            border: `2px solid ${error ? colors.error : colors.mutedBorder}`,
            fontSize: typography.cardTitle.fontSize,
            fontWeight: '600',
          }}
        />
      ))}
    </div>
  );
};
