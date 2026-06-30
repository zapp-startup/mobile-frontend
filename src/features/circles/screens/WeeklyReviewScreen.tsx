import React, { useState } from 'react';
import { useNavigate } from 'react-router';
import { AppScreen } from '../../../shared/components/AppScreen';
import { AppHeader } from '../../../shared/components/AppHeader';
import { AppCard } from '../../../shared/components/AppCard';
import { AppButton } from '../../../shared/components/AppButton';
import { AppTextarea } from '../../../shared/components/AppTextarea';
import { SectionHeader } from '../../../shared/components/SectionHeader';
import { ReflectionDialog } from '../components/ReflectionDialog';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';

export const WeeklyReviewScreen: React.FC = () => {
  const navigate = useNavigate();
  const [reflectionOpen, setReflectionOpen] = useState(false);
  const [answers, setAnswers] = useState<Record<string, string>>({});

  const prompts = [
    { id: '1', question: 'What was your biggest financial win this week?' },
    { id: '2', question: 'What would you do differently with your spending?' },
    { id: '3', question: 'What are you planning for next week?' },
  ];

  const reviewedCount = 5;
  const pendingCount = 3;

  return (
    <AppScreen>
      <AppHeader title="Weekly Review" showBack />

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

        <SectionHeader title="Reflection Questions" />

        {prompts.map((prompt) => (
          <AppCard key={prompt.id}>
            <AppTextarea
              label={prompt.question}
              value={answers[prompt.id] || ''}
              onChange={(value) => setAnswers({ ...answers, [prompt.id]: value })}
              placeholder="Your thoughts..."
              rows={3}
            />
          </AppCard>
        ))}

        <AppButton fullWidth onClick={() => navigate(-1)}>
          Submit Review
        </AppButton>
      </div>

      <ReflectionDialog
        isOpen={reflectionOpen}
        onClose={() => setReflectionOpen(false)}
        onSave={(reflection) => console.log('Reflection:', reflection)}
      />
    </AppScreen>
  );
};
