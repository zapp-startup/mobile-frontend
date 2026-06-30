import React from 'react';
import { Building2 } from 'lucide-react';
import { AppEmptyState } from '../../../shared/components/AppEmptyState';

interface BankingEmptyStateProps {
  onConnect: () => void;
}

export const BankingEmptyState: React.FC<BankingEmptyStateProps> = ({ onConnect }) => {
  return (
    <AppEmptyState
      icon={<Building2 size={48} />}
      title="No bank connections"
      description="Connect your bank account to automatically track transactions and get personalized insights."
      actionLabel="Connect Bank"
      onAction={onConnect}
    />
  );
};
