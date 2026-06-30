import React, { useState } from 'react';
import { AppSheet } from '../../../shared/components/AppSheet';
import { AppSelect } from '../../../shared/components/AppSelect';
import { AppInput } from '../../../shared/components/AppInput';
import { AppButton } from '../../../shared/components/AppButton';

interface TransactionFilters {
  category: string;
  type: string;
  dateFrom: string;
  dateTo: string;
}

interface TransactionFilterSheetProps {
  isOpen: boolean;
  onClose: () => void;
  filters: TransactionFilters;
  onApply: (filters: TransactionFilters) => void;
}

export const TransactionFilterSheet: React.FC<TransactionFilterSheetProps> = ({
  isOpen,
  onClose,
  filters,
  onApply,
}) => {
  const [localFilters, setLocalFilters] = useState(filters);

  const categories = [
    { value: '', label: 'All Categories' },
    { value: 'groceries', label: 'Groceries' },
    { value: 'dining', label: 'Dining' },
    { value: 'transportation', label: 'Transportation' },
    { value: 'entertainment', label: 'Entertainment' },
    { value: 'subscriptions', label: 'Subscriptions' },
  ];

  const types = [
    { value: '', label: 'All Types' },
    { value: 'income', label: 'Income' },
    { value: 'expense', label: 'Expense' },
  ];

  const handleApply = () => {
    onApply(localFilters);
    onClose();
  };

  const handleClear = () => {
    const clearedFilters = { category: '', type: '', dateFrom: '', dateTo: '' };
    setLocalFilters(clearedFilters);
    onApply(clearedFilters);
    onClose();
  };

  return (
    <AppSheet isOpen={isOpen} onClose={onClose} title="Filter Transactions">
      <div className="space-y-4">
        <AppSelect
          label="Category"
          value={localFilters.category}
          onChange={(value) => setLocalFilters({ ...localFilters, category: value })}
          options={categories}
        />

        <AppSelect
          label="Type"
          value={localFilters.type}
          onChange={(value) => setLocalFilters({ ...localFilters, type: value })}
          options={types}
        />

        <AppInput
          label="Date From"
          type="date"
          value={localFilters.dateFrom}
          onChange={(value) => setLocalFilters({ ...localFilters, dateFrom: value })}
        />

        <AppInput
          label="Date To"
          type="date"
          value={localFilters.dateTo}
          onChange={(value) => setLocalFilters({ ...localFilters, dateTo: value })}
        />

        <div className="flex gap-3 mt-6">
          <AppButton variant="secondary" onClick={handleClear} fullWidth>
            Clear
          </AppButton>
          <AppButton onClick={handleApply} fullWidth>
            Apply
          </AppButton>
        </div>
      </div>
    </AppSheet>
  );
};
