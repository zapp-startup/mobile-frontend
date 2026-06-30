import React, { useState } from 'react';
import { AppSheet } from '../../../shared/components/AppSheet';
import { AppInput } from '../../../shared/components/AppInput';
import { AppButton } from '../../../shared/components/AppButton';

interface AddPreferenceSheetProps {
  isOpen: boolean;
  onClose: () => void;
  onAdd: (category: string, value: string) => void;
}

export const AddPreferenceSheet: React.FC<AddPreferenceSheetProps> = ({
  isOpen,
  onClose,
  onAdd,
}) => {
  const [category, setCategory] = useState('');
  const [value, setValue] = useState('');
  const [error, setError] = useState('');

  const handleAdd = () => {
    if (!category.trim() || !value.trim()) {
      setError('Both fields are required');
      return;
    }

    onAdd(category, value);
    setCategory('');
    setValue('');
    setError('');
  };

  return (
    <AppSheet isOpen={isOpen} onClose={onClose} title="Add Preference">
      <div className="space-y-4">
        <AppInput
          label="Category"
          value={category}
          onChange={setCategory}
          placeholder="e.g., Food"
          error={error}
        />

        <AppInput
          label="Preference"
          value={value}
          onChange={setValue}
          placeholder="e.g., Organic"
          error={error}
        />

        <div className="flex gap-3">
          <AppButton variant="secondary" onClick={onClose} fullWidth>
            Cancel
          </AppButton>
          <AppButton onClick={handleAdd} fullWidth>
            Add
          </AppButton>
        </div>
      </div>
    </AppSheet>
  );
};
