import React, { useState } from 'react';
import { AppModal } from '../../../shared/components/AppModal';
import { AppButton } from '../../../shared/components/AppButton';
import { AppTextarea } from '../../../shared/components/AppTextarea';
import { SliderQuestion } from '../../onboarding/components/SliderQuestion';
import { AppSelect } from '../../../shared/components/AppSelect';
import { SectionHeader } from '../../../shared/components/SectionHeader';

interface ReflectionDialogProps {
  isOpen: boolean;
  onClose: () => void;
  onSave: (reflection: any) => void;
}

export const ReflectionDialog: React.FC<ReflectionDialogProps> = ({
  isOpen,
  onClose,
  onSave,
}) => {
  const [regret, setRegret] = useState(50);
  const [worthIt, setWorthIt] = useState('');
  const [notes, setNotes] = useState('');

  const handleSave = () => {
    onSave({ regret, worthIt, notes });
    setRegret(50);
    setWorthIt('');
    setNotes('');
    onClose();
  };

  return (
    <AppModal isOpen={isOpen} onClose={onClose} title="Transaction Reflection">
      <div className="space-y-6">
        <div>
          <SectionHeader title="Regret score" />
          <SliderQuestion
            value={regret}
            onChange={setRegret}
            min={0}
            max={100}
            labels={{ min: 'No regret', max: 'Full regret' }}
          />
        </div>

        <div>
          <AppSelect
            label="Was it worth it?"
            value={worthIt}
            onChange={setWorthIt}
            options={[
              { value: 'yes', label: 'Yes' },
              { value: 'maybe', label: 'Maybe' },
              { value: 'no', label: 'No' },
            ]}
            placeholder="Select..."
          />
        </div>

        <div>
          <AppTextarea
            label="Notes"
            value={notes}
            onChange={setNotes}
            placeholder="Your thoughts..."
            rows={4}
          />
        </div>

        <div className="flex gap-3">
          <AppButton variant="secondary" onClick={onClose} fullWidth>
            Cancel
          </AppButton>
          <AppButton onClick={handleSave} fullWidth>
            Save
          </AppButton>
        </div>
      </div>
    </AppModal>
  );
};
