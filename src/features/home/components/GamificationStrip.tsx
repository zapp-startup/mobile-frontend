import React from 'react';
import { Flame, Trophy, Target } from 'lucide-react';
import { AppCard } from '../../../shared/components/AppCard';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';

interface GamificationStripProps {
  streak: number;
  badges: number;
  targetsCompleted: number;
  onClick?: () => void;
}

export const GamificationStrip: React.FC<GamificationStripProps> = ({
  streak,
  badges,
  targetsCompleted,
  onClick,
}) => {
  return (
    <AppCard onClick={onClick}>
      <div className="grid grid-cols-3 gap-4">
        <div className="flex flex-col items-center">
          <div
            className="p-2 rounded-full mb-2"
            style={{ backgroundColor: `${colors.warning}20` }}
          >
            <Flame size={20} color={colors.warning} />
          </div>
          <p
            style={{
              fontSize: typography.cardTitle.fontSize,
              fontWeight: '700',
              color: colors.primaryText,
            }}
          >
            {streak}
          </p>
          <p
            style={{
              fontSize: typography.caption,
              color: colors.secondaryText,
            }}
          >
            Day Streak
          </p>
        </div>

        <div className="flex flex-col items-center">
          <div
            className="p-2 rounded-full mb-2"
            style={{ backgroundColor: `${colors.accent}20` }}
          >
            <Trophy size={20} color={colors.accent} />
          </div>
          <p
            style={{
              fontSize: typography.cardTitle.fontSize,
              fontWeight: '700',
              color: colors.primaryText,
            }}
          >
            {badges}
          </p>
          <p
            style={{
              fontSize: typography.caption,
              color: colors.secondaryText,
            }}
          >
            Badges
          </p>
        </div>

        <div className="flex flex-col items-center">
          <div
            className="p-2 rounded-full mb-2"
            style={{ backgroundColor: `${colors.success}20` }}
          >
            <Target size={20} color={colors.success} />
          </div>
          <p
            style={{
              fontSize: typography.cardTitle.fontSize,
              fontWeight: '700',
              color: colors.primaryText,
            }}
          >
            {targetsCompleted}
          </p>
          <p
            style={{
              fontSize: typography.caption,
              color: colors.secondaryText,
            }}
          >
            Targets
          </p>
        </div>
      </div>
    </AppCard>
  );
};
