import React from 'react';
import { useLocation, useNavigate } from 'react-router';
import { TabIcon } from '../shared/components/TabIcon';
import { colors } from '../shared/theme/colors';
import { spacing } from '../shared/theme/spacing';
import { typography } from '../shared/theme/typography';

export const MainTabNavigator: React.FC = () => {
  const location = useLocation();
  const navigate = useNavigate();

  const tabs = [
    { name: 'home' as const, label: 'Home', path: '/' },
    { name: 'transactions' as const, label: 'Transactions', path: '/transactions' },
    { name: 'subscriptions' as const, label: 'Subscriptions', path: '/subscriptions' },
    { name: 'circles' as const, label: 'Circles', path: '/circles' },
    { name: 'profile' as const, label: 'Profile', path: '/profile' },
  ];

  const getIsActive = (path: string) => {
    if (path === '/') {
      return location.pathname === '/';
    }
    return location.pathname.startsWith(path);
  };

  return (
    <nav
      className="fixed bottom-0 left-0 right-0 z-50 safe-area-pb"
      style={{
        backgroundColor: colors.elevatedSurface,
        borderTop: `1px solid ${colors.mutedBorder}`,
        paddingBottom: 'env(safe-area-inset-bottom)',
      }}
    >
      <div className="flex items-center justify-around" style={{ padding: spacing.md }}>
        {tabs.map((tab) => {
          const isActive = getIsActive(tab.path);
          
          return (
            <button
              key={tab.name}
              onClick={() => navigate(tab.path)}
              className="flex flex-col items-center gap-1 py-2 px-3 min-w-0 transition-all active:scale-95"
            >
              <TabIcon name={tab.name} active={isActive} size={24} />
              <span
                className="text-xs truncate"
                style={{
                  color: isActive ? colors.accent : colors.secondaryText,
                  fontSize: typography.caption,
                  fontWeight: isActive ? '600' : '400',
                }}
              >
                {tab.label}
              </span>
            </button>
          );
        })}
      </div>
    </nav>
  );
};
