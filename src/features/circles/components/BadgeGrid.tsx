import React from 'react';
import { Award, Lock } from 'lucide-react';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';
import { radii } from '../../../shared/theme/radii';
import { Badge } from '../../../shared/utils/mockShapes';

interface BadgeGridProps {
  badges: Badge[];
}

export const BadgeGrid: React.FC<BadgeGridProps> = ({ badges }) => {
  return (
    <div className="grid grid-cols-3 gap-3">
      {badges.map((badge) => (
        <div
          key={badge.id}
          className="flex flex-col items-center p-3 text-center"
          style={{
            backgroundColor: badge.isLocked ? colors.subtleSurface : colors.elevatedSurface,
            borderRadius: radii.lg,
            opacity: badge.isLocked ? 0.5 : 1,
          }}
        >
          <div
            className="w-12 h-12 rounded-full flex items-center justify-center mb-2"
            style={{
              backgroundColor: badge.isLocked ? colors.mutedBorder : `${colors.accent}20`,
            }}
          >
            {badge.isLocked ? (
              <Lock size={20} color={colors.secondaryText} />
            ) : (
              <Award size={20} color={colors.accent} />
            )}
          </div>
          
          <p
            className="truncate w-full"
            style={{
              fontSize: typography.caption,
              fontWeight: '600',
              color: colors.primaryText,
            }}
          >
            {badge.name}
          </p>
          
          {badge.unlockedDate && !badge.isLocked && (
            <p
              style={{
                fontSize: typography.caption,
                color: colors.secondaryText,
              }}
            >
              Unlocked
            </p>
          )}
        </div>
      ))}
    </div>
  );
};
