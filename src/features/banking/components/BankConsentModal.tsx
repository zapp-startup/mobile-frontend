import React from 'react';
import { Shield } from 'lucide-react';
import { AppModal } from '../../../shared/components/AppModal';
import { AppButton } from '../../../shared/components/AppButton';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';

interface BankConsentModalProps {
  isOpen: boolean;
  onClose: () => void;
  onConsent: () => void;
}

export const BankConsentModal: React.FC<BankConsentModalProps> = ({
  isOpen,
  onClose,
  onConsent,
}) => {
  return (
    <AppModal isOpen={isOpen} onClose={onClose} title="Bank Connection Consent">
      <div className="space-y-4">
        <div className="flex justify-center">
          <div
            className="p-4 rounded-full"
            style={{ backgroundColor: `${colors.accent}20` }}
          >
            <Shield size={48} color={colors.accent} />
          </div>
        </div>

        <div>
          <p style={{ fontSize: typography.body.fontSize, color: colors.primaryText, marginBottom: '1rem' }}>
            By connecting your bank account, you authorize Zapp to:
          </p>

          <ul className="space-y-2" style={{ fontSize: typography.small.fontSize, color: colors.secondaryText }}>
            <li>• Access your account balances and transaction history</li>
            <li>• Categorize and analyze your spending patterns</li>
            <li>• Calculate value scores for your purchases</li>
            <li>• Provide personalized financial insights</li>
          </ul>

          <p
            className="mt-4"
            style={{ fontSize: typography.small.fontSize, color: colors.secondaryText }}
          >
            Your data is encrypted and secure. We will never share your financial information
            with third parties without your explicit consent.
          </p>
        </div>

        <div className="space-y-3 pt-4">
          <AppButton fullWidth onClick={onConsent}>
            I Understand, Continue
          </AppButton>
          <AppButton variant="secondary" fullWidth onClick={onClose}>
            Cancel
          </AppButton>
        </div>
      </div>
    </AppModal>
  );
};
