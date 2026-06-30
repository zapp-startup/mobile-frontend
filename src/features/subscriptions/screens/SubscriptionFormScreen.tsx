import React, { useState } from 'react';
import { useNavigate, useParams } from 'react-router';
import { AppScreen } from '../../../shared/components/AppScreen';
import { AppHeader } from '../../../shared/components/AppHeader';
import { AppCard } from '../../../shared/components/AppCard';
import { AppInput } from '../../../shared/components/AppInput';
import { AppSelect } from '../../../shared/components/AppSelect';
import { AppTextarea } from '../../../shared/components/AppTextarea';
import { AppButton } from '../../../shared/components/AppButton';

export const SubscriptionFormScreen: React.FC = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const isEdit = !!id;

  const [merchant, setMerchant] = useState('');
  const [amount, setAmount] = useState('');
  const [billingCycle, setBillingCycle] = useState('monthly');
  const [startDate, setStartDate] = useState('');
  const [notes, setNotes] = useState('');
  const [errors, setErrors] = useState<Record<string, string>>({});

  const handleSubmit = () => {
    const newErrors: Record<string, string> = {};
    if (!merchant) newErrors.merchant = 'Merchant is required';
    if (!amount) newErrors.amount = 'Amount is required';
    if (!startDate) newErrors.startDate = 'Start date is required';

    if (Object.keys(newErrors).length > 0) {
      setErrors(newErrors);
      return;
    }

    console.log('Submitting subscription:', { merchant, amount, billingCycle, startDate, notes });
    navigate(-1);
  };

  return (
    <AppScreen>
      <AppHeader title={isEdit ? 'Edit Subscription' : 'New Subscription'} showBack />

      <div className="px-4 py-6">
        <AppCard>
          <div className="space-y-4">
            <AppInput
              label="Merchant"
              value={merchant}
              onChange={setMerchant}
              placeholder="e.g., Netflix"
              error={errors.merchant}
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
              label="Billing Cycle"
              value={billingCycle}
              onChange={setBillingCycle}
              options={[
                { value: 'weekly', label: 'Weekly' },
                { value: 'monthly', label: 'Monthly' },
                { value: 'yearly', label: 'Yearly' },
              ]}
              required
            />

            <AppInput
              label="Start Date"
              type="date"
              value={startDate}
              onChange={setStartDate}
              error={errors.startDate}
              required
            />

            <AppTextarea
              label="Notes"
              value={notes}
              onChange={setNotes}
              placeholder="Add any notes about this subscription..."
              rows={3}
            />

            <div className="space-y-3 pt-4">
              <AppButton fullWidth onClick={handleSubmit}>
                {isEdit ? 'Save Changes' : 'Add Subscription'}
              </AppButton>

              <AppButton variant="secondary" fullWidth onClick={() => navigate(-1)}>
                Cancel
              </AppButton>
            </div>
          </div>
        </AppCard>
      </div>
    </AppScreen>
  );
};
