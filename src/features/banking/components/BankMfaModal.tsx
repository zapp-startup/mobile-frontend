import React, { useState } from 'react';
import { AppModal } from '../../../shared/components/AppModal';
import { AppButton } from '../../../shared/components/AppButton';
import { MfaCodeField } from '../../auth/components/MfaCodeField';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';

interface BankMfaModalProps {
  isOpen: boolean;
  onClose: () => void;
  onVerify: (code: string) => void;
}

export const BankMfaModal: React.FC<BankMfaModalProps> = ({
  isOpen,
  onClose,
  onVerify,
}) => {
  const [code, setCode] = useState('');
  const [error, setError] = useState(false);

  const handleVerify = () => {
    if (code.length !== 6) {
      setError(true);
      return;
    }
    onVerify(code);
    setCode('');
    setError(false);
  };

  return (
    <AppModal isOpen={isOpen} onClose={onClose} title="Bank MFA Verification">
      <div className="space-y-4">
        <p style={{ fontSize: typography.body.fontSize, color: colors.primaryText, textAlign: 'center' }}>
          Your bank requires additional verification. Please enter the 6-digit code.
        </p>

        <div className="py-4">
          <MfaCodeField value={code} onChange={setCode} error={error} />
          
          {error && (
            <p
              className="text-center mt-2"
              style={{ fontSize: typography.small.fontSize, color: colors.error }}
            >
              Invalid code. Please try again.
            </p>
          )}
        </div>

        <div className="space-y-3">
          <AppButton fullWidth onClick={handleVerify} disabled={code.length !== 6}>
            Verify
          </AppButton>
          <AppButton variant="secondary" fullWidth onClick={onClose}>
            Cancel
          </AppButton>
        </div>
      </div>
    </AppModal>
  );
};
