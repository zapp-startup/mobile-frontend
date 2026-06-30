import React, { useState } from 'react';
import { AppScreen } from '../../../shared/components/AppScreen';
import { AppHeader } from '../../../shared/components/AppHeader';
import { AppCard } from '../../../shared/components/AppCard';
import { AppInput } from '../../../shared/components/AppInput';
import { SectionHeader } from '../../../shared/components/SectionHeader';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';

export const SearchScreen: React.FC = () => {
  const [query, setQuery] = useState('');

  return (
    <AppScreen>
      <AppHeader title="Search" showBack />

      <div className="px-4 py-6 space-y-4">
        <AppInput
          value={query}
          onChange={setQuery}
          placeholder="Search transactions, subscriptions, circles..."
        />

        <AppCard>
          <SectionHeader title="Search Tips" />
          <ul className="space-y-2 mt-4" style={{ fontSize: typography.small.fontSize, color: colors.secondaryText }}>
            <li>• Search by merchant name or description</li>
            <li>• Find transactions by category</li>
            <li>• Look up subscription details</li>
            <li>• Search within circles and members</li>
          </ul>
        </AppCard>

        {query && (
          <AppCard>
            <p style={{ fontSize: typography.body.fontSize, color: colors.secondaryText, textAlign: 'center' }}>
              No results found for "{query}"
            </p>
          </AppCard>
        )}
      </div>
    </AppScreen>
  );
};
