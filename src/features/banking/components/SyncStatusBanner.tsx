import React from 'react';
import { Loader2, CheckCircle, AlertCircle } from 'lucide-react';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';
import { radii } from '../../../shared/theme/radii';

interface SyncStatusBannerProps {
  status: 'syncing' | 'success' | 'error';
  message: string;
}

export const SyncStatusBanner: React.FC<SyncStatusBannerProps> = ({ status, message }) => {
  const config = {
    syncing: { icon: Loader2, color: colors.accent, bg: `${colors.accent}20` },
    success: { icon: CheckCircle, color: colors.success, bg: `${colors.success}20` },
    error: { icon: AlertCircle, color: colors.error, bg: `${colors.error}20` },
  }[status];

  const Icon = config.icon;

  return (
    <div
      className="flex items-center gap-3 p-3"
      style={{
        backgroundColor: config.bg,
        borderRadius: radii.lg,
      }}
    >
      <Icon
        size={20}
        color={config.color}
        className={status === 'syncing' ? 'animate-spin' : ''}
      />
      
      <p
        style={{
          fontSize: typography.small.fontSize,
          color: config.color,
          fontWeight: '500',
        }}
      >
        {message}
      </p>
    </div>
  );
};
