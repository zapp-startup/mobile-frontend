import React, { useState } from 'react';
import { useNavigate } from 'react-router';
import { AppScreen } from '../../../shared/components/AppScreen';
import { AppHeader } from '../../../shared/components/AppHeader';
import { AppCard } from '../../../shared/components/AppCard';
import { AppButton } from '../../../shared/components/AppButton';
import { AppSelect } from '../../../shared/components/AppSelect';
import { MfaCodeField } from '../components/MfaCodeField';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';
import { SectionHeader } from '../../../shared/components/SectionHeader';

export const MfaVerifyScreen: React.FC = () => {
  const navigate = useNavigate();
  const [factor, setFactor] = useState('');
  const [code, setCode] = useState('');
  const [error, setError] = useState(false);
  const [loading, setLoading] = useState(false);

  const factors = [
    { value: 'totp', label: 'Authenticator App' },
    { value: 'sms', label: 'SMS' },
  ];

  const handleVerify = () => {
    if (!factor || code.length !== 6) {
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
      <AppHeader title="Two-Factor Authentication" showBack />

      <div className="px-4 py-6">
        <AppCard>
          <SectionHeader
            title="Verify your identity"
            subtitle="Enter the code from your authenticator"
          />

          <div className="space-y-4 mt-6">
            <AppSelect
              label="Authentication Method"
              value={factor}
              onChange={setFactor}
              options={factors}
              placeholder="Select a method"
              required
            />

            {factor && (
              <>
                <div className="pt-2">
                  <p
                    className="mb-4 text-center"
                    style={{ color: colors.secondaryText, fontSize: typography.small.fontSize }}
                  >
                    Enter the 6-digit code
                  </p>
                  
                  <MfaCodeField value={code} onChange={setCode} error={error} />

                  {error && (
                    <p className="text-center mt-2" style={{ color: colors.error, fontSize: typography.small.fontSize }}>
                      {!factor ? 'Please select an authentication method' : 'Invalid code. Please try again.'}
                    </p>
                  )}
                </div>

                <div className="mt-6">
                  <AppButton
                    fullWidth
                    onClick={handleVerify}
                    loading={loading}
                    disabled={!factor || code.length !== 6}
                  >
                    Verify and continue
                  </AppButton>
                </div>
              </>
            )}
          </div>
        </AppCard>
      </div>
    </AppScreen>
  );
};
