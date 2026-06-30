import React, { useState } from 'react';
import { AppSheet } from '../../../shared/components/AppSheet';
import { AppButton } from '../../../shared/components/AppButton';
import { AppTextarea } from '../../../shared/components/AppTextarea';
import { AppSelect } from '../../../shared/components/AppSelect';
import { SliderQuestion } from '../../onboarding/components/SliderQuestion';
import { SectionHeader } from '../../../shared/components/SectionHeader';

interface TransactionFeedbackSheetProps {
  isOpen: boolean;
  onClose: () => void;
  transactionId: string;
  onSubmit: (feedback: any) => void;
}

export const TransactionFeedbackSheet: React.FC<TransactionFeedbackSheetProps> = ({
  isOpen,
  onClose,
  transactionId,
  onSubmit,
}) => {
  const [worthIt, setWorthIt] = useState('');
  const [regret, setRegret] = useState(50);
  const [repurchase, setRepurchase] = useState(50);
  const [usageFrequency, setUsageFrequency] = useState('');
  const [reflection, setReflection] = useState('');

  const handleSubmit = () => {
    onSubmit({
      transactionId,
      worthIt,
      regret,
      repurchase,
      usageFrequency,
      reflection,
    });
    onClose();
  };

  return (
    <AppSheet isOpen={isOpen} onClose={onClose} title="Transaction Feedback">
      <div className="space-y-6">
        <div>
          <SectionHeader title="Was it worth it?" />
          <AppSelect
            value={worthIt}
            onChange={setWorthIt}
            options={[
              { value: 'yes', label: 'Yes, worth it' },
              { value: 'maybe', label: 'Maybe' },
              { value: 'no', label: 'Not worth it' },
            ]}
            placeholder="Select..."
          />
        </div>

        <div>
          <SectionHeader title="Regret level (0-100)" />
          <SliderQuestion
            value={regret}
            onChange={setRegret}
            min={0}
            max={100}
            labels={{ min: 'No regret', max: 'Full regret' }}
          />
        </div>

        <div>
          <SectionHeader title="Repurchase likelihood (0-100)" />
          <SliderQuestion
            value={repurchase}
            onChange={setRepurchase}
            min={0}
            max={100}
            labels={{ min: 'Never again', max: 'Definitely' }}
          />
        </div>

        <div>
          <SectionHeader title="Usage frequency" />
          <AppSelect
            value={usageFrequency}
            onChange={setUsageFrequency}
            options={[
              { value: 'daily', label: 'Daily' },
              { value: 'weekly', label: 'Weekly' },
              { value: 'monthly', label: 'Monthly' },
              { value: 'rarely', label: 'Rarely' },
              { value: 'once', label: 'One-time' },
            ]}
            placeholder="Select..."
          />
        </div>

        <div>
          <AppTextarea
            label="Reflection"
            value={reflection}
            onChange={setReflection}
            placeholder="Share your thoughts about this purchase..."
            rows={4}
          />
        </div>

        <div className="flex gap-3">
          <AppButton variant="secondary" onClick={onClose} fullWidth>
            Cancel
          </AppButton>
          <AppButton onClick={handleSubmit} fullWidth>
            Submit Feedback
          </AppButton>
        </div>
      </div>
    </AppSheet>
  );
};
