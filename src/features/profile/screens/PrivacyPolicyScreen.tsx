import React from 'react';
import { AppScreen } from '../../../shared/components/AppScreen';
import { AppHeader } from '../../../shared/components/AppHeader';
import { AppCard } from '../../../shared/components/AppCard';
import { SectionHeader } from '../../../shared/components/SectionHeader';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';

export const PrivacyPolicyScreen: React.FC = () => {
  const sections = [
    {
      title: 'Information Collection',
      content: 'We collect information you provide directly to us, including financial data, transactions, and preferences.',
    },
    {
      title: 'Data Usage',
      content: 'Your data is used to provide personalized financial insights, track spending patterns, and improve our services.',
    },
    {
      title: 'Data Security',
      content: 'We implement industry-standard security measures to protect your financial information.',
    },
    {
      title: 'Third-Party Services',
      content: 'We use secure third-party services like Plaid for bank connections and Spotify for subscription insights.',
    },
    {
      title: 'Your Rights',
      content: 'You have the right to access, modify, or delete your data at any time through your profile settings.',
    },
  ];

  return (
    <AppScreen>
      <AppHeader title="Privacy Policy" showBack />

      <div className="px-4 py-6 space-y-4">
        <AppCard>
          <div className="flex justify-between mb-4">
            <div>
              <p style={{ fontSize: typography.small.fontSize, color: colors.secondaryText }}>
                Version
              </p>
              <p
                className="mt-1"
                style={{
                  fontSize: typography.body.fontSize,
                  fontWeight: '600',
                  color: colors.primaryText,
                }}
              >
                2.0.1
              </p>
            </div>

            <div className="text-right">
              <p style={{ fontSize: typography.small.fontSize, color: colors.secondaryText }}>
                Effective Date
              </p>
              <p
                className="mt-1"
                style={{
                  fontSize: typography.body.fontSize,
                  fontWeight: '600',
                  color: colors.primaryText,
                }}
              >
                January 1, 2026
              </p>
            </div>
          </div>

          <p style={{ fontSize: typography.body.fontSize, color: colors.secondaryText, lineHeight: '1.6' }}>
            This Privacy Policy explains how Zapp collects, uses, and protects your personal and financial information.
          </p>
        </AppCard>

        {sections.map((section, index) => (
          <AppCard key={index}>
            <SectionHeader title={section.title} />
            <p
              className="mt-3"
              style={{
                fontSize: typography.small.fontSize,
                color: colors.secondaryText,
                lineHeight: '1.6',
              }}
            >
              {section.content}
            </p>
          </AppCard>
        ))}
      </div>
    </AppScreen>
  );
};
