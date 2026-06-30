import React from 'react';
import { ChevronRight } from 'lucide-react';
import { AppCard } from '../../../shared/components/AppCard';
import { SectionHeader } from '../../../shared/components/SectionHeader';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';
import { formatCurrency } from '../../../shared/utils/formatters';

interface Category {
  name: string;
  amount: number;
  percentage: number;
  color: string;
}

interface CategoryBreakdownCardProps {
  categories: Category[];
  onViewAll?: () => void;
}

export const CategoryBreakdownCard: React.FC<CategoryBreakdownCardProps> = ({
  categories,
  onViewAll,
}) => {
  return (
    <AppCard>
      <SectionHeader title="Spending by Category" />

      <div className="space-y-3">
        {categories.map((category, index) => (
          <div key={index}>
            <div className="flex items-center justify-between mb-1">
              <span style={{ fontSize: typography.small.fontSize, color: colors.primaryText }}>
                {category.name}
              </span>
              <span
                style={{
                  fontSize: typography.small.fontSize,
                  fontWeight: '600',
                  color: colors.primaryText,
                }}
              >
                {formatCurrency(category.amount)}
              </span>
            </div>
            
            <div
              className="h-2 rounded-full overflow-hidden"
              style={{ backgroundColor: colors.mutedBorder }}
            >
              <div
                className="h-full transition-all duration-300"
                style={{
                  width: `${category.percentage}%`,
                  backgroundColor: category.color,
                }}
              />
            </div>
            
            <p
              className="mt-1"
              style={{ fontSize: typography.caption, color: colors.secondaryText }}
            >
              {category.percentage}% of spending
            </p>
          </div>
        ))}
      </div>

      {onViewAll && (
        <button
          onClick={onViewAll}
          className="flex items-center justify-center gap-1 w-full mt-4 py-2"
          style={{ color: colors.accent, fontSize: typography.small.fontSize, fontWeight: '500' }}
        >
          View Analytics
          <ChevronRight size={16} />
        </button>
      )}
    </AppCard>
  );
};
