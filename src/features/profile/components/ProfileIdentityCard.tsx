import React from 'react';
import { Mail, Award } from 'lucide-react';
import { AppCard } from '../../../shared/components/AppCard';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';
import { formatInitials } from '../../../shared/utils/formatters';
import { User } from '../../../shared/utils/mockShapes';

interface ProfileIdentityCardProps {
  user: User;
}

export const ProfileIdentityCard: React.FC<ProfileIdentityCardProps> = ({ user }) => {
  return (
    <AppCard>
      <div className="flex items-center gap-4">
        <div
          className="w-16 h-16 rounded-full flex items-center justify-center"
          style={{ backgroundColor: colors.accent }}
        >
          <span
            style={{
              fontSize: typography.sectionTitle.fontSize,
              fontWeight: '700',
              color: colors.white,
            }}
          >
            {formatInitials(user.name)}
          </span>
        </div>

        <div className="flex-1">
          <h2
            style={{
              fontSize: typography.cardTitle.fontSize,
              fontWeight: typography.cardTitle.fontWeight,
              color: colors.primaryText,
            }}
          >
            {user.name}
          </h2>
          
          <div className="flex items-center gap-2 mt-1">
            <Mail size={14} color={colors.secondaryText} />
            <span
              style={{
                fontSize: typography.small.fontSize,
                color: colors.secondaryText,
              }}
            >
              {user.email}
            </span>
          </div>

          <div className="flex items-center gap-2 mt-1">
            <Award size={14} color={colors.accent} />
            <span
              style={{
                fontSize: typography.small.fontSize,
                fontWeight: '500',
                color: colors.accent,
              }}
            >
              {user.tier}
            </span>
          </div>
        </div>
      </div>
    </AppCard>
  );
};
