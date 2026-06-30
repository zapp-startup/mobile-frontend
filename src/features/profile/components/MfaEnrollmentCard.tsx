import React from 'react';
import { Shield, CheckCircle } from 'lucide-react';
import { AppCard } from '../../../shared/components/AppCard';
import { AppButton } from '../../../shared/components/AppButton';
import { SectionHeader } from '../../../shared/components/SectionHeader';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';

interface MfaEnrollmentCardProps {
  mfaEnabled: boolean;
  onSetup: () => void;
  onManage: () => void;
}

export const MfaEnrollmentCard: React.FC<MfaEnrollmentCardProps> = ({
  mfaEnabled,
  onSetup,
  onManage,
}) => {
  return (
    <AppCard>
      <div className="flex items-start gap-3 mb-4">
        <div
          className="p-2 rounded-lg"
          style={{ backgroundColor: mfaEnabled ? `${colors.success}20` : `${colors.warning}20` }}
        >
          {mfaEnabled ? (
            <CheckCircle size={20} color={colors.success} />
          ) : (
            <Shield size={20} color={colors.warning} />
          )}
        </div>
        
        <div className="flex-1">
          <SectionHeader
            title="Two-Factor Authentication"
            subtitle={mfaEnabled ? 'Enabled' : 'Not enabled'}
          />
          
          <p
            className="mt-2"
            style={{
              fontSize: typography.small.fontSize,
              color: colors.secondaryText,
            }}
          >
            {mfaEnabled
              ? 'Your account is protected with 2FA'
              : 'Add an extra layer of security to your account'}
          </p>
        </div>
      </div>

      {mfaEnabled ? (
        <AppButton variant="secondary" fullWidth onClick={onManage}>
          Manage 2FA
        </AppButton>
      ) : (
        <AppButton fullWidth onClick={onSetup}>
          Setup 2FA
        </AppButton>
      )}
    </AppCard>
  );
};
