import React from 'react';
import { Users, ChevronRight, Lock } from 'lucide-react';
import { AppCard } from '../../../shared/components/AppCard';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';
import { Circle } from '../../../shared/utils/mockShapes';

interface CircleCardProps {
  circle: Circle;
  onClick?: () => void;
}

export const CircleCard: React.FC<CircleCardProps> = ({ circle, onClick }) => {
  return (
    <AppCard onClick={onClick}>
      <div className="flex items-center gap-3">
        <div
          className="p-3 rounded-lg"
          style={{ backgroundColor: `${colors.accent}20` }}
        >
          <Users size={24} color={colors.accent} />
        </div>

        <div className="flex-1 min-w-0">
          <div className="flex items-center gap-2">
            <h3
              className="truncate"
              style={{
                fontSize: typography.cardTitle.fontSize,
                fontWeight: typography.cardTitle.fontWeight,
                color: colors.primaryText,
              }}
            >
              {circle.name}
            </h3>
            {circle.isPrivate && <Lock size={14} color={colors.secondaryText} />}
          </div>
          
          <p
            className="mt-1"
            style={{
              fontSize: typography.small.fontSize,
              color: colors.secondaryText,
            }}
          >
            {circle.memberCount} {circle.memberCount === 1 ? 'member' : 'members'}
            {circle.rank !== undefined && ` • Rank #${circle.rank}`}
          </p>
        </div>

        <ChevronRight size={20} color={colors.secondaryText} />
      </div>
    </AppCard>
  );
};
