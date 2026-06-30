import React from 'react';
import { Search } from 'lucide-react';
import { colors } from '../../../shared/theme/colors';
import { spacing } from '../../../shared/theme/spacing';
import { radii } from '../../../shared/theme/radii';
import { typography } from '../../../shared/theme/typography';

interface TransactionSearchBarProps {
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
}

export const TransactionSearchBar: React.FC<TransactionSearchBarProps> = ({
  value,
  onChange,
  placeholder = 'Search transactions...',
}) => {
  return (
    <div className="relative">
      <Search
        size={18}
        className="absolute left-3 top-1/2 transform -translate-y-1/2"
        color={colors.secondaryText}
      />
      <input
        type="text"
        value={value}
        onChange={(e) => onChange(e.target.value)}
        placeholder={placeholder}
        className="w-full pl-10 pr-4 focus:outline-none focus:ring-2 transition-all"
        style={{
          padding: `${spacing.md} ${spacing.md} ${spacing.md} 2.5rem`,
          backgroundColor: colors.elevatedSurface,
          color: colors.primaryText,
          borderRadius: radii.lg,
          border: `1px solid ${colors.mutedBorder}`,
          fontSize: typography.body.fontSize,
        }}
      />
    </div>
  );
};
