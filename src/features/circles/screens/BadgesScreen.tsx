import React from 'react';
import { AppScreen } from '../../../shared/components/AppScreen';
import { AppHeader } from '../../../shared/components/AppHeader';
import { AppCard } from '../../../shared/components/AppCard';
import { BadgeGrid } from '../components/BadgeGrid';
import { SectionHeader } from '../../../shared/components/SectionHeader';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';
import { Badge } from '../../../shared/utils/mockShapes';

export const BadgesScreen: React.FC = () => {
  const mockBadges: Badge[] = [
    { id: '1', name: 'First Transaction', description: 'Track your first transaction', unlockedDate: '2024-01-15', isLocked: false },
    { id: '2', name: '7 Day Streak', description: 'Log in for 7 days straight', unlockedDate: '2024-02-01', isLocked: false },
    { id: '3', name: 'Budget Master', description: 'Stay under budget for a month', unlockedDate: '2024-03-01', isLocked: false },
    { id: '4', name: 'Savings Goal', description: 'Reach your savings target', isLocked: true },
    { id: '5', name: 'Value Hunter', description: 'Rate 20 transactions', isLocked: true },
    { id: '6', name: 'Circle Leader', description: 'Rank #1 in a circle', isLocked: true },
  ];

  const unlockedCount = mockBadges.filter((b) => !b.isLocked).length;

  return (
    <AppScreen>
      <AppHeader title="Badges" showBack />

      <div className="px-4 py-6 space-y-4">
        <div className="grid grid-cols-2 gap-4">
          <AppCard>
            <p style={{ fontSize: typography.small.fontSize, color: colors.secondaryText }}>
              Total Badges
            </p>
            <p
              className="mt-1"
              style={{
                fontSize: typography.displayTitle.fontSize,
                fontWeight: '700',
                color: colors.primaryText,
              }}
            >
              {mockBadges.length}
            </p>
          </AppCard>

          <AppCard>
            <p style={{ fontSize: typography.small.fontSize, color: colors.secondaryText }}>
              Unlocked
            </p>
            <p
              className="mt-1"
              style={{
                fontSize: typography.displayTitle.fontSize,
                fontWeight: '700',
                color: colors.accent,
              }}
            >
              {unlockedCount}
            </p>
          </AppCard>
        </div>

        <SectionHeader title="All Badges" />
        <BadgeGrid badges={mockBadges} />
      </div>
    </AppScreen>
  );
};
