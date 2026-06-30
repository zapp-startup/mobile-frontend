import React, { useState } from 'react';
import { AppModal } from '../../../shared/components/AppModal';
import { AppInput } from '../../../shared/components/AppInput';
import { AppButton } from '../../../shared/components/AppButton';

interface JoinCircleModalProps {
  isOpen: boolean;
  onClose: () => void;
  onJoin: (code: string) => void;
}

export const JoinCircleModal: React.FC<JoinCircleModalProps> = ({
  isOpen,
  onClose,
  onJoin,
}) => {
  const [code, setCode] = useState('');
  const [error, setError] = useState('');

  const handleJoin = () => {
    if (!code.trim()) {
      setError('Invite code is required');
      return;
    }

    onJoin(code);
    setCode('');
    setError('');
    onClose();
  };

  return (
    <AppModal isOpen={isOpen} onClose={onClose} title="Join Circle">
      <div className="space-y-4">
        <AppInput
          label="Invite Code"
          value={code}
          onChange={setCode}
          placeholder="Enter invite code"
          error={error}
          required
        />

        <div className="space-y-3 pt-4">
          <AppButton fullWidth onClick={handleJoin}>
            Join Circle
          </AppButton>
          <AppButton variant="secondary" fullWidth onClick={onClose}>
            Cancel
          </AppButton>
        </div>
      </div>
    </AppModal>
  );
};
