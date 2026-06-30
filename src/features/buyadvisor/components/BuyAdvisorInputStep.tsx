import React from 'react';
import { AppInput } from '../../../shared/components/AppInput';
import { AppSelect } from '../../../shared/components/AppSelect';
import { AppButton } from '../../../shared/components/AppButton';

interface BuyAdvisorInputStepProps {
  predictedPrice: string;
  category: string;
  onPriceChange: (value: string) => void;
  onCategoryChange: (value: string) => void;
  onAnalyze: () => void;
  onCancel: () => void;
}

export const BuyAdvisorInputStep: React.FC<BuyAdvisorInputStepProps> = ({
  predictedPrice,
  category,
  onPriceChange,
  onCategoryChange,
  onAnalyze,
  onCancel,
}) => {
  return (
    <div className="space-y-4">
      <AppInput
        label="Predicted Price"
        type="number"
        value={predictedPrice}
        onChange={onPriceChange}
        placeholder="0.00"
        required
      />

      <AppSelect
        label="Category"
        value={category}
        onChange={onCategoryChange}
        options={[
          { value: 'electronics', label: 'Electronics' },
          { value: 'clothing', label: 'Clothing' },
          { value: 'groceries', label: 'Groceries' },
          { value: 'dining', label: 'Dining' },
          { value: 'entertainment', label: 'Entertainment' },
          { value: 'other', label: 'Other' },
        ]}
        placeholder="Select category"
        required
      />

      <div className="space-y-3 pt-4">
        <AppButton
          fullWidth
          onClick={onAnalyze}
          disabled={!predictedPrice || !category}
        >
          Analyze Purchase
        </AppButton>

        <AppButton variant="secondary" fullWidth onClick={onCancel}>
          Cancel
        </AppButton>
      </div>
    </div>
  );
};
