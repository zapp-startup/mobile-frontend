import React from 'react';
import { useParams, useNavigate } from 'react-router';
import { LogOut, UserPlus } from 'lucide-react';
import { AppScreen } from '../../../shared/components/AppScreen';
import { AppHeader } from '../../../shared/components/AppHeader';
import { AppCard } from '../../../shared/components/AppCard';
import { AppButton } from '../../../shared/components/AppButton';
import { SectionHeader } from '../../../shared/components/SectionHeader';
import { InviteCodeCard } from '../components/InviteCodeCard';
import { MemberRow } from '../components/MemberRow';
import { LeaderboardRow } from '../components/LeaderboardRow';
import { StatusChip } from '../../../shared/components/StatusChip';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';

export const CircleDetailScreen: React.FC = () => {
  const { id } = useParams();
  const navigate = useNavigate();

  const circle = {
    id,
    name: 'Family Finance',
    memberCount: 4,
    isPrivate: true,
    inviteCode: 'FAM123',
    rank: 2,
    members: [
      { id: '1', name: 'John Doe', joinedDate: '2024-01-15', role: 'admin' as const },
      { id: '2', name: 'Jane Doe', joinedDate: '2024-01-20', role: 'member' as const },
      { id: '3', name: 'Bob Smith', joinedDate: '2024-02-01', role: 'member' as const },
    ],
    leaderboard: [
      { userId: '2', userName: 'Jane Doe', score: 1250, rank: 1 },
      { userId: '1', userName: 'John Doe', score: 1180, rank: 2 },
      { userId: '3', userName: 'Bob Smith', score: 950, rank: 3 },
    ],
  };

  return (
    <AppScreen>
      <AppHeader title={circle.name} showBack />

      <div className="px-4 py-6 space-y-4">
        <AppCard>
          <div className="flex items-center justify-between">
            <div>
              <p style={{ fontSize: typography.small.fontSize, color: colors.secondaryText }}>
                Privacy
              </p>
              <StatusChip
                label={circle.isPrivate ? 'Private' : 'Public'}
                variant={circle.isPrivate ? 'warning' : 'success'}
                className="mt-1"
              />
            </div>

            <div className="text-right">
              <p style={{ fontSize: typography.small.fontSize, color: colors.secondaryText }}>
                Your Rank
              </p>
              <p
                className="mt-1"
                style={{
                  fontSize: typography.cardTitle.fontSize,
                  fontWeight: '700',
                  color: colors.accent,
                }}
              >
                #{circle.rank}
              </p>
            </div>

            <div className="text-right">
              <p style={{ fontSize: typography.small.fontSize, color: colors.secondaryText }}>
                Members
              </p>
              <p
                className="mt-1"
                style={{
                  fontSize: typography.cardTitle.fontSize,
                  fontWeight: '700',
                  color: colors.primaryText,
                }}
              >
                {circle.memberCount}
              </p>
            </div>
          </div>
        </AppCard>

        {circle.inviteCode && <InviteCodeCard code={circle.inviteCode} />}

        <div>
          <SectionHeader title="Leaderboard" subtitle="This week" />
          <div className="space-y-2">
            {circle.leaderboard.map((entry) => (
              <LeaderboardRow key={entry.userId} entry={entry} />
            ))}
          </div>
        </div>

        <div>
          <SectionHeader title="Members" subtitle={`${circle.members?.length || 0} members`} />
          <div className="space-y-2">
            {circle.members?.map((member) => (
              <MemberRow key={member.id} member={member} />
            ))}
          </div>
        </div>

        <AppButton variant="danger" fullWidth>
          <LogOut size={16} className="inline mr-2" />
          Leave Circle
        </AppButton>
      </div>
    </AppScreen>
  );
};
