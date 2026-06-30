import React from 'react';
import { useNavigate } from 'react-router';
import { Plus } from 'lucide-react';
import { AppScreen } from '../../../shared/components/AppScreen';
import { AppHeader } from '../../../shared/components/AppHeader';
import { AppEmptyState } from '../../../shared/components/AppEmptyState';
import { TargetCard } from '../components/TargetCard';
import { SectionHeader } from '../../../shared/components/SectionHeader';
import { Target } from '../../../shared/utils/mockShapes';
import { colors } from '../../../shared/theme/colors';

export const TargetsScreen: React.FC = () => {
  const navigate = useNavigate();

  const mockTargets: Target[] = [
    {
      id: '1',
      title: 'Emergency Fund',
      type: 'savings',
      targetValue: 5000,
      currentValue: 3200,
      progress: 64,
    },
    {
      id: '2',
      title: 'Reduce Dining Out',
      type: 'spending',
      targetValue: 200,
      currentValue: 150,
      progress: 75,
    },
    {
      id: '3',
      title: 'Side Income Goal',
      type: 'income',
      targetValue: 1000,
      currentValue: 450,
      progress: 45,
    },
  ];

  const hasTargets = mockTargets.length > 0;

  return (
    <AppScreen>
      <AppHeader
        title="Targets"
        showBack
        rightActions={
          hasTargets && (
            <button
              onClick={() => console.log('Create target')}
              className="p-2 rounded-lg active:opacity-70 transition-opacity"
              style={{ color: colors.accent }}
            >
              <Plus size={20} />
            </button>
          )
        }
      />

      <div className="px-4 py-6 space-y-4">
        {hasTargets ? (
          <>
            <SectionHeader title="Active Targets" subtitle={`${mockTargets.length} goals in progress`} />
            <div className="space-y-3">
              {mockTargets.map((target) => (
                <TargetCard key={target.id} target={target} />
              ))}
            </div>
          </>
        ) : (
          <AppEmptyState
            title="No targets set"
            description="Set financial targets to track your progress towards your goals"
            actionLabel="Create Target"
            onAction={() => console.log('Create target')}
          />
        )}
      </div>
    </AppScreen>
  );
};
