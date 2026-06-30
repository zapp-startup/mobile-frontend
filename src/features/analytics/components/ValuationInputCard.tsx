import React, { useState } from 'react';
import { AppCard } from '../../../shared/components/AppCard';
import { AppInput } from '../../../shared/components/AppInput';
import { AppButton } from '../../../shared/components/AppButton';
import { SectionHeader } from '../../../shared/components/SectionHeader';

interface ValuationInputCardProps {
  onCompute: (description: string, amount: number) => void;
}

export const ValuationInputCard: React.FC<ValuationInputCardProps> = ({ onCompute }) => {
  const [description, setDescription] = useState('');
  const [amount, setAmount] = useState('');

  const handleCompute = () => {
    if (description && amount) {
      onCompute(description, parseFloat(amount));
      setDescription('');
      setAmount('');
    }
  };

  return (
    <AppCard>
      <SectionHeader
        title="Valuation Calculator"
        subtitle="Get AI-powered value analysis"
      />

      <div className="space-y-3 mt-4">
        <AppInput
          label="Description"
          value={description}
          onChange={setDescription}
          placeholder="What are you considering?"
        />

        <AppInput
          label="Amount ($)"
          type="number"
          value={amount}
          onChange={setAmount}
          placeholder="0.00"
        />

        <AppButton
          fullWidth
          onClick={handleCompute}
          disabled={!description || !amount}
        >
          Calculate Value Score
        </AppButton>
      </div>
    </AppCard>
  );
};
