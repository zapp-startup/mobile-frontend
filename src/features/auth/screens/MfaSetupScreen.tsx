import React, { useState } from 'react';
import { useNavigate } from 'react-router';
import { AppScreen } from '../../../shared/components/AppScreen';
import { AppHeader } from '../../../shared/components/AppHeader';
import { AppCard } from '../../../shared/components/AppCard';
import { AppButton } from '../../../shared/components/AppButton';
import { MfaCodeField } from '../components/MfaCodeField';
import { colors } from '../../../shared/theme/colors';
import { spacing } from '../../../shared/theme/spacing';
import { typography } from '../../../shared/theme/typography';
import { SectionHeader } from '../../../shared/components/SectionHeader';

export const MfaSetupScreen: React.FC = () => {
  const navigate = useNavigate();
  const [code, setCode] = useState('');
  const [error, setError] = useState(false);
  const [loading, setLoading] = useState(false);

  const qrCodeUrl = 'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=otpauth://totp/Zapp:user@example.com?secret=JBSWY3DPEHPK3PXP&issuer=Zapp';

  const handleVerify = () => {
    if (code.length !== 6) {
      setError(true);
      return;
    }

    setError(false);
    setLoading(true);

    // Simulate API call
    setTimeout(() => {
      navigate('/');
      setLoading(false);
    }, 1000);
  };

  return (
    <AppScreen>
      <AppHeader title="MFA Setup" showBack />

      <div className="px-4 py-6 space-y-6">
        <AppCard>
          <SectionHeader
            title="Set up authenticator"
            subtitle="Scan the QR code with your authenticator app"
          />

          <div className="flex justify-center my-6">
            <img
              src={qrCodeUrl}
              alt="QR Code"
              style={{
                borderRadius: '12px',
                border: `2px solid ${colors.mutedBorder}`,
              }}
            />
          </div>

          <div
            className="p-3 rounded-lg mb-4"
            style={{ backgroundColor: colors.subtleSurface }}
          >
            <p
              className="text-center font-mono"
              style={{ color: colors.primaryText, fontSize: typography.small.fontSize }}
            >
              JBSWY3DPEHPK3PXP
            </p>
            <p
              className="text-center mt-1"
              style={{ color: colors.secondaryText, fontSize: typography.caption }}
            >
              Manual entry key
            </p>
          </div>

          <p
            className="mb-4"
            style={{ color: colors.secondaryText, fontSize: typography.small.fontSize }}
          >
            Enter the 6-digit code from your authenticator app to verify setup
          </p>

          <MfaCodeField value={code} onChange={setCode} error={error} />

          {error && (
            <p className="text-center mt-2" style={{ color: colors.error, fontSize: typography.small.fontSize }}>
              Invalid code. Please try again.
            </p>
          )}

          <div className="mt-6 space-y-3">
            <AppButton fullWidth onClick={handleVerify} loading={loading} disabled={code.length !== 6}>
              Confirm and continue
            </AppButton>

            <AppButton fullWidth variant="ghost" onClick={() => navigate('/')}>
              Skip for now
            </AppButton>
          </div>
        </AppCard>

        <p
          className="text-center"
          style={{ color: colors.secondaryText, fontSize: typography.small.fontSize }}
        >
          MFA adds an extra layer of security to your account
        </p>
      </div>
    </AppScreen>
  );
};
