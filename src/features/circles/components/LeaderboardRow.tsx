import React from 'react';
import { Trophy } from 'lucide-react';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';
import { radii } from '../../../shared/theme/radii';
import { LeaderboardEntry } from '../../../shared/utils/mockShapes';

interface LeaderboardRowProps {
  entry: LeaderboardEntry;
}

export const LeaderboardRow: React.FC<LeaderboardRowProps> = ({ entry }) => {
  const getRankColor = (rank: number) => {
    if (rank === 1) return colors.warning;
    if (rank === 2) return colors.secondaryText;
    if (rank === 3) return colors.warning;
    return colors.secondaryText;
  };

  return (
    <div
      className="flex items-center gap-3 p-3"
      style={{
        backgroundColor: colors.elevatedSurface,
        borderRadius: radii.lg,
      }}
    >
      <div
        className="w-8 h-8 rounded-full flex items-center justify-center"
        style={{
          backgroundColor: entry.rank <= 3 ? `${getRankColor(entry.rank)}20` : colors.subtleSurface,
        }}
      >
        {entry.rank <= 3 ? (
          <Trophy size={16} color={getRankColor(entry.rank)} />
        ) : (
          <span
            style={{
              fontSize: typography.small.fontSize,
              fontWeight: '600',
              color: colors.secondaryText,
            }}
          >
            {entry.rank}
          </span>
        )}
      </div>

      <div className="flex-1 min-w-0">
        <p
          className="truncate"
          style={{
            fontSize: typography.body.fontSize,
            fontWeight: '500',
            color: colors.primaryText,
          }}
        >
          {entry.userName}
        </p>
      </div>

      <span
        style={{
          fontSize: typography.cardTitle.fontSize,
          fontWeight: '700',
          color: colors.accent,
        }}
      >
        {entry.score}
      </span>
    </div>
  );
};
