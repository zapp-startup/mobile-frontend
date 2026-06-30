import React, { useState } from 'react';
import { Edit2, Check } from 'lucide-react';
import { AppCard } from '../../../shared/components/AppCard';
import { AppInput } from '../../../shared/components/AppInput';
import { AppSelect } from '../../../shared/components/AppSelect';
import { SectionHeader } from '../../../shared/components/SectionHeader';
import { FinancialProfile } from '../../../shared/utils/mockShapes';
import { colors } from '../../../shared/theme/colors';

interface FinancialProfileCardProps {
  profile: Partial<FinancialProfile>;
  onSave: (profile: Partial<FinancialProfile>) => void;
}

export const FinancialProfileCard: React.FC<FinancialProfileCardProps> = ({
  profile: initialProfile,
  onSave,
}) => {
  const [isEditing, setIsEditing] = useState(false);
  const [profile, setProfile] = useState(initialProfile);

  const handleSave = () => {
    onSave(profile);
    setIsEditing(false);
  };

  return (
    <AppCard>
      <SectionHeader
        title="Financial Profile"
        action={
          <button
            onClick={() => (isEditing ? handleSave() : setIsEditing(true))}
            className="p-2 rounded-lg active:opacity-70 transition-opacity"
            style={{ color: colors.accent }}
          >
            {isEditing ? <Check size={20} /> : <Edit2 size={20} />}
          </button>
        }
      />

      <div className="space-y-3 mt-4">
        {isEditing ? (
          <>
            <AppSelect
              label="Life Stage"
              value={profile.lifeStage || ''}
              onChange={(value) => setProfile({ ...profile, lifeStage: value })}
              options={[
                { value: 'student', label: 'Student' },
                { value: 'early-career', label: 'Early Career' },
                { value: 'established', label: 'Established' },
                { value: 'pre-retirement', label: 'Pre-Retirement' },
              ]}
            />

            <AppInput
              label="Household Size"
              type="number"
              value={profile.householdSize?.toString() || ''}
              onChange={(value) => setProfile({ ...profile, householdSize: parseInt(value) })}
            />

            <AppInput
              label="Zip Code"
              value={profile.zipCode || ''}
              onChange={(value) => setProfile({ ...profile, zipCode: value })}
            />

            <AppSelect
              label="Income Range"
              value={profile.incomeRange || ''}
              onChange={(value) => setProfile({ ...profile, incomeRange: value })}
              options={[
                { value: '0-30k', label: '$0-30k' },
                { value: '30-60k', label: '$30-60k' },
                { value: '60-100k', label: '$60-100k' },
                { value: '100-150k', label: '$100-150k' },
                { value: '150k+', label: '$150k+' },
              ]}
            />
          </>
        ) : (
          <>
            <div className="flex justify-between py-2" style={{ borderBottom: `1px solid ${colors.mutedBorder}` }}>
              <span style={{ color: colors.secondaryText }}>Life Stage</span>
              <span style={{ color: colors.primaryText }}>{profile.lifeStage || 'Not set'}</span>
            </div>

            <div className="flex justify-between py-2" style={{ borderBottom: `1px solid ${colors.mutedBorder}` }}>
              <span style={{ color: colors.secondaryText }}>Household Size</span>
              <span style={{ color: colors.primaryText }}>{profile.householdSize || 'Not set'}</span>
            </div>

            <div className="flex justify-between py-2" style={{ borderBottom: `1px solid ${colors.mutedBorder}` }}>
              <span style={{ color: colors.secondaryText }}>Zip Code</span>
              <span style={{ color: colors.primaryText }}>{profile.zipCode || 'Not set'}</span>
            </div>

            <div className="flex justify-between py-2">
              <span style={{ color: colors.secondaryText }}>Income Range</span>
              <span style={{ color: colors.primaryText }}>{profile.incomeRange || 'Not set'}</span>
            </div>
          </>
        )}
      </div>
    </AppCard>
  );
};
