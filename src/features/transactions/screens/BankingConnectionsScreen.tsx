import React, { useState } from 'react';
import { useNavigate } from 'react-router';
import { Plus, Shield } from 'lucide-react';
import { AppScreen } from '../../../shared/components/AppScreen';
import { AppHeader } from '../../../shared/components/AppHeader';
import { AppButton } from '../../../shared/components/AppButton';
import { AppCard } from '../../../shared/components/AppCard';
import { BankConnectionCard } from '../../banking/components/BankConnectionCard';
import { BankingEmptyState } from '../../banking/components/BankingEmptyState';
import { BankConsentModal } from '../../banking/components/BankConsentModal';
import { SyncStatusBanner } from '../../banking/components/SyncStatusBanner';
import { SectionHeader } from '../../../shared/components/SectionHeader';
import { BankConnection } from '../../../shared/utils/mockShapes';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';

export const BankingConnectionsScreen: React.FC = () => {
  const navigate = useNavigate();
  const [consentModalOpen, setConsentModalOpen] = useState(false);
  const [isSyncing, setIsSyncing] = useState(false);

  // Mock data
  const mockConnections: BankConnection[] = [
    {
      id: '1',
      institutionName: 'Chase Bank',
      status: 'connected',
      lastSynced: '2026-04-15',
      accounts: [
        { id: '1', name: 'Checking', type: 'checking', mask: '1234', balance: 2450.75 },
        { id: '2', name: 'Savings', type: 'savings', mask: '5678', balance: 10000.00 },
      ],
    },
  ];

  const hasConnections = mockConnections.length > 0;

  const handleConnect = () => {
    setConsentModalOpen(true);
  };

  const handleConsent = () => {
    setConsentModalOpen(false);
    // Simulate Plaid flow
    console.log('Initiating Plaid flow...');
  };

  return (
    <AppScreen>
      <AppHeader
        title="Bank Connections"
        showBack
        rightActions={
          hasConnections && (
            <button
              onClick={handleConnect}
              className="p-2 rounded-lg active:opacity-70 transition-opacity"
              style={{ color: colors.accent }}
            >
              <Plus size={20} />
            </button>
          )
        }
      />

      <div className="px-4 py-6 space-y-4">
        <AppCard>
          <div className="flex items-center gap-3 mb-4">
            <div
              className="p-2 rounded-lg"
              style={{ backgroundColor: `${colors.success}20` }}
            >
              <Shield size={20} color={colors.success} />
            </div>
            <div className="flex-1">
              <p
                style={{
                  fontSize: typography.small.fontSize,
                  fontWeight: '500',
                  color: colors.primaryText,
                }}
              >
                Bank-level security
              </p>
              <p
                style={{
                  fontSize: typography.caption,
                  color: colors.secondaryText,
                }}
              >
                Your data is encrypted and never shared
              </p>
            </div>
          </div>
        </AppCard>

        {isSyncing && (
          <SyncStatusBanner status="syncing" message="Syncing your bank accounts..." />
        )}

        {hasConnections ? (
          <>
            <SectionHeader title="Connected Banks" />
            
            <div className="space-y-3">
              {mockConnections.map((connection) => (
                <BankConnectionCard
                  key={connection.id}
                  connection={connection}
                  onClick={() => navigate(`/transactions/banking/${connection.id}`)}
                />
              ))}
            </div>

            <AppButton variant="secondary" fullWidth onClick={handleConnect}>
              <Plus size={20} className="inline mr-2" />
              Connect Another Bank
            </AppButton>
          </>
        ) : (
          <BankingEmptyState onConnect={handleConnect} />
        )}
      </div>

      <BankConsentModal
        isOpen={consentModalOpen}
        onClose={() => setConsentModalOpen(false)}
        onConsent={handleConsent}
      />
    </AppScreen>
  );
};
