import React, { useState } from 'react';
import { useNavigate } from 'react-router';
import { Plus, UserPlus } from 'lucide-react';
import { AppScreen } from '../../../shared/components/AppScreen';
import { AppHeader } from '../../../shared/components/AppHeader';
import { AppEmptyState } from '../../../shared/components/AppEmptyState';
import { CircleCard } from '../components/CircleCard';
import { CreateCircleModal } from '../components/CreateCircleModal';
import { JoinCircleModal } from '../components/JoinCircleModal';
import { SectionHeader } from '../../../shared/components/SectionHeader';
import { Circle } from '../../../shared/utils/mockShapes';
import { colors } from '../../../shared/theme/colors';

export const CirclesScreen: React.FC = () => {
  const navigate = useNavigate();
  const [createModalOpen, setCreateModalOpen] = useState(false);
  const [joinModalOpen, setJoinModalOpen] = useState(false);

  const mockCircles: Circle[] = [
    {
      id: '1',
      name: 'Family Finance',
      memberCount: 4,
      isPrivate: true,
      inviteCode: 'FAM123',
      rank: 2,
    },
    {
      id: '2',
      name: 'College Savers',
      memberCount: 12,
      isPrivate: false,
      rank: 7,
    },
  ];

  const hasCircles = mockCircles.length > 0;

  return (
    <AppScreen>
      <AppHeader
        title="Circles"
        rightActions={
          <div className="flex items-center gap-2">
            <button
              onClick={() => setJoinModalOpen(true)}
              className="p-2 rounded-lg active:opacity-70 transition-opacity"
              style={{ color: colors.primaryText }}
            >
              <UserPlus size={20} />
            </button>
            <button
              onClick={() => setCreateModalOpen(true)}
              className="p-2 rounded-lg active:opacity-70 transition-opacity"
              style={{ color: colors.accent }}
            >
              <Plus size={20} />
            </button>
          </div>
        }
      />

      <div className="px-4 py-6 space-y-4">
        {hasCircles ? (
          <>
            <SectionHeader title="My Circles" subtitle={`${mockCircles.length} circles`} />
            <div className="space-y-3">
              {mockCircles.map((circle) => (
                <CircleCard
                  key={circle.id}
                  circle={circle}
                  onClick={() => navigate(`/circles/${circle.id}`)}
                />
              ))}
            </div>
          </>
        ) : (
          <AppEmptyState
            title="No circles yet"
            description="Join or create a circle to compete with friends and family on financial goals"
            actionLabel="Create Circle"
            onAction={() => setCreateModalOpen(true)}
          />
        )}
      </div>

      <CreateCircleModal
        isOpen={createModalOpen}
        onClose={() => setCreateModalOpen(false)}
        onCreate={(name, isPrivate) => console.log('Create circle:', name, isPrivate)}
      />

      <JoinCircleModal
        isOpen={joinModalOpen}
        onClose={() => setJoinModalOpen(false)}
        onJoin={(code) => console.log('Join circle:', code)}
      />
    </AppScreen>
  );
};
