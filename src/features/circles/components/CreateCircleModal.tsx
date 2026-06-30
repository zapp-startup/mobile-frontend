import React, { useState } from 'react';
import { AppModal } from '../../../shared/components/AppModal';
import { AppInput } from '../../../shared/components/AppInput';
import { AppButton } from '../../../shared/components/AppButton';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';

interface CreateCircleModalProps {
  isOpen: boolean;
  onClose: () => void;
  onCreate: (name: string, isPrivate: boolean) => void;
}

export const CreateCircleModal: React.FC<CreateCircleModalProps> = ({
  isOpen,
  onClose,
  onCreate,
}) => {
  const [name, setName] = useState('');
  const [isPrivate, setIsPrivate] = useState(false);
  const [error, setError] = useState('');

  const handleCreate = () => {
    if (!name.trim()) {
      setError('Circle name is required');
      return;
    }

    onCreate(name, isPrivate);
    setName('');
    setIsPrivate(false);
    setError('');
    onClose();
  };

  return (
    <AppModal isOpen={isOpen} onClose={onClose} title="Create Circle">
      <div className="space-y-4">
        <AppInput
          label="Circle Name"
          value={name}
          onChange={setName}
          placeholder="My Finance Circle"
          error={error}
          required
        />

        <div className="flex items-center justify-between p-3 rounded-lg" style={{ backgroundColor: colors.subtleSurface }}>
          <div>
            <p style={{ fontSize: typography.body.fontSize, color: colors.primaryText, fontWeight: '500' }}>
              Private Circle
            </p>
            <p style={{ fontSize: typography.small.fontSize, color: colors.secondaryText }}>
              Only members with invite code can join
            </p>
          </div>
          <button
            onClick={() => setIsPrivate(!isPrivate)}
            className="relative inline-flex h-6 w-11 items-center rounded-full transition-colors"
            style={{ backgroundColor: isPrivate ? colors.accent : colors.mutedBorder }}
          >
            <span
              className={`inline-block h-4 w-4 transform rounded-full bg-white transition-transform ${
                isPrivate ? 'translate-x-6' : 'translate-x-1'
              }`}
            />
          </button>
        </div>

        <div className="space-y-3 pt-4">
          <AppButton fullWidth onClick={handleCreate}>
            Create Circle
          </AppButton>
          <AppButton variant="secondary" fullWidth onClick={onClose}>
            Cancel
          </AppButton>
        </div>
      </div>
    </AppModal>
  );
};
