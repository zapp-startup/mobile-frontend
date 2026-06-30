import React, { useState } from 'react';
import { useNavigate, useParams } from 'react-router';
import { AppScreen } from '../../../shared/components/AppScreen';
import { AppHeader } from '../../../shared/components/AppHeader';
import { AppCard } from '../../../shared/components/AppCard';
import { AppInput } from '../../../shared/components/AppInput';
import { AppSelect } from '../../../shared/components/AppSelect';
import { AppButton } from '../../../shared/components/AppButton';

export const TransactionFormScreen: React.FC = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const isEdit = !!id;

  const [description, setDescription] = useState('');
  const [amount, setAmount] = useState('');
  const [type, setType] = useState('expense');
  const [category, setCategory] = useState('');
  const [date, setDate] = useState('');
  const [errors, setErrors] = useState<Record<string, string>>({});

  const handleSubmit = () => {
    const newErrors: Record<string, string> = {};
    if (!description) newErrors.description = 'Description is required';
    if (!amount) newErrors.amount = 'Amount is required';
    if (!category) newErrors.category = 'Category is required';
    if (!date) newErrors.date = 'Date is required';

    if (Object.keys(newErrors).length > 0) {
      setErrors(newErrors);
      return;
    }

    console.log('Submitting transaction:', { description, amount, type, category, date });
    navigate(-1);
  };

  return (
    <AppScreen>
      <AppHeader title={isEdit ? 'Edit Transaction' : 'New Transaction'} showBack />

      <div className="px-4 py-6">
        <AppCard>
          <div className="space-y-4">
            <AppInput
              label="Description"
              value={description}
              onChange={setDescription}
              placeholder="e.g., Whole Foods"
              error={errors.description}
              required
            />

            <AppInput
              label="Amount"
              type="number"
              value={amount}
              onChange={setAmount}
              placeholder="0.00"
              error={errors.amount}
              required
            />

            <AppSelect
              label="Type"
              value={type}
              onChange={setType}
              options={[
                { value: 'expense', label: 'Expense' },
                { value: 'income', label: 'Income' },
              ]}
              required
            />

            <AppSelect
              label="Category"
              value={category}
              onChange={setCategory}
              options={[
                { value: 'groceries', label: 'Groceries' },
                { value: 'dining', label: 'Dining' },
                { value: 'transportation', label: 'Transportation' },
                { value: 'entertainment', label: 'Entertainment' },
                { value: 'subscriptions', label: 'Subscriptions' },
                { value: 'income', label: 'Income' },
              ]}
              placeholder="Select category"
              error={errors.category}
              required
            />

            <AppInput
              label="Date"
              type="date"
              value={date}
              onChange={setDate}
              error={errors.date}
              required
            />

            <div className="space-y-3 pt-4">
              <AppButton fullWidth onClick={handleSubmit}>
                {isEdit ? 'Save Changes' : 'Add Transaction'}
              </AppButton>

              <AppButton variant="secondary" fullWidth onClick={() => navigate(-1)}>
                Cancel
              </AppButton>

              {isEdit && (
                <AppButton variant="danger" fullWidth>
                  Delete Transaction
                </AppButton>
              )}
            </div>
          </div>
        </AppCard>
      </div>
    </AppScreen>
  );
};
