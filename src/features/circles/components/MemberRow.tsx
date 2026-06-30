import React from 'react';
import { MoreVertical } from 'lucide-react';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';
import { radii } from '../../../shared/theme/radii';
import { formatDateShort } from '../../../shared/utils/formatters';
import { CircleMember } from '../../../shared/utils/mockShapes';

interface MemberRowProps {
  member: CircleMember;
  onMore?: () => void;
}

export const MemberRow: React.FC<MemberRowProps> = ({ member, onMore }) => {
  return (
    <div
      className="flex items-center gap-3 p-3"
      style={{
        backgroundColor: colors.elevatedSurface,
        borderRadius: radii.lg,
      }}
    >
      <div
        className="w-10 h-10 rounded-full flex items-center justify-center"
        style={{ backgroundColor: colors.accent }}
      >
        <span
          style={{
            fontSize: typography.body.fontSize,
            fontWeight: '600',
            color: colors.white,
          }}
        >
          {member.name[0]}
        </span>
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
          {member.name}
        </p>
        <p
          style={{
            fontSize: typography.small.fontSize,
            color: colors.secondaryText,
          }}
        >
          {member.role} • Joined {formatDateShort(member.joinedDate)}
        </p>
      </div>

      {onMore && (
        <button
          onClick={onMore}
          className="p-1"
          style={{ color: colors.secondaryText }}
        >
          <MoreVertical size={16} />
        </button>
      )}
    </div>
  );
};
