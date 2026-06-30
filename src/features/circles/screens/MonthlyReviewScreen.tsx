import React, { useState } from 'react';
import { useNavigate } from 'react-router';
import { AppScreen } from '../../../shared/components/AppScreen';
import { AppHeader } from '../../../shared/components/AppHeader';
import { AppCard } from '../../../shared/components/AppCard';
import { AppButton } from '../../../shared/components/AppButton';
import { AppTextarea } from '../../../shared/components/AppTextarea';
import { SectionHeader } from '../../../shared/components/SectionHeader';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';

export const MonthlyReviewScreen: React.FC = () => {
  const navigate = useNavigate();
  const [answers, setAnswers] = useState<Record<string, string>>({});

  const prompts = [
    { id: '1', question: 'How well did you stick to your budget this month?' },
    { id: '2', question: 'What were your biggest expenses and were they worthwhile?' },
    { id: '3', question: 'What financial goals will you focus on next month?' },
    { id: '4', question: 'Did you achieve any targets or milestones?' },
  ];

  const reviewedCount = 42;
  const pendingCount = 8;

  return (
    <AppScreen>
      <AppHeader title="Monthly Review" showBack />

      <div className="px-4 py-6 space-y-4">
        <div className="grid grid-cols-2 gap-3">
          <AppCard>
            <p style={{ fontSize: typography.small.fontSize, color: colors.secondaryText }}>
              Reviewed
            </p>
            <p
              className="mt-1"
              style={{
                fontSize: typography.displayTitle.fontSize,
                fontWeight: '700',
                color: colors.success,
              }}
            >
              {reviewedCount}
            </p>
          </AppCard>

          <AppCard>
            <p style={{ fontSize: typography.small.fontSize, color: colors.secondaryText }}>
              Pending
            </p>
            <p
              className="mt-1"
              style={{
                fontSize: typography.displayTitle.fontSize,
                fontWeight: '700',
                color: colors.warning,
              }}
            >
              {pendingCount}
            </p>
          </AppCard>
        </div>

        <SectionHeader title="Monthly Reflection" subtitle="Take time to review your financial month" />

        {prompts.map((prompt) => (
          <AppCard key={prompt.id}>
            <AppTextarea
              label={prompt.question}
              value={answers[prompt.id] || ''}
              onChange={(value) => setAnswers({ ...answers, [prompt.id]: value })}
              placeholder="Your thoughts..."
              rows={4}
            />
          </AppCard>
        ))}

        <AppButton fullWidth onClick={() => navigate(-1)}>
          Submit Monthly Review
        </AppButton>
      </div>
    </AppScreen>
  );
};
