import React from 'react';
import { Music, RefreshCw, Link as LinkIcon, Unlink } from 'lucide-react';
import { AppCard } from '../../../shared/components/AppCard';
import { AppButton } from '../../../shared/components/AppButton';
import { SectionHeader } from '../../../shared/components/SectionHeader';
import { StatusChip } from '../../../shared/components/StatusChip';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';
import { SpotifyConnection } from '../../../shared/utils/mockShapes';

interface SpotifyIntegrationCardProps {
  connection: SpotifyConnection;
  onConnect: () => void;
  onSync: () => void;
  onDisconnect: () => void;
}

export const SpotifyIntegrationCard: React.FC<SpotifyIntegrationCardProps> = ({
  connection,
  onConnect,
  onSync,
  onDisconnect,
}) => {
  const statusVariants = {
    connected: 'success' as const,
    disconnected: 'neutral' as const,
    syncing: 'info' as const,
    error: 'error' as const,
  };

  return (
    <AppCard>
      <div className="flex items-start gap-3 mb-4">
        <div
          className="p-2 rounded-lg"
          style={{ backgroundColor: `${colors.success}20` }}
        >
          <Music size={20} color={colors.success} />
        </div>
        <div className="flex-1">
          <SectionHeader title="Spotify Integration" />
          <p style={{ fontSize: typography.small.fontSize, color: colors.secondaryText }}>
            Connect your Spotify account to enhance valuation
          </p>
        </div>
      </div>

      <div className="space-y-3">
        <div className="flex items-center justify-between">
          <span style={{ fontSize: typography.small.fontSize, color: colors.secondaryText }}>
            Status
          </span>
          <StatusChip label={connection.status} variant={statusVariants[connection.status]} />
        </div>

        {connection.connected && connection.displayInfo && (
          <>
            <div className="flex items-center justify-between">
              <span style={{ fontSize: typography.small.fontSize, color: colors.secondaryText }}>
                Account
              </span>
              <span
                style={{
                  fontSize: typography.small.fontSize,
                  fontWeight: '500',
                  color: colors.primaryText,
                }}
              >
                {connection.displayInfo.accountName}
              </span>
            </div>

            <div className="flex items-center justify-between">
              <span style={{ fontSize: typography.small.fontSize, color: colors.secondaryText }}>
                Product
              </span>
              <span
                style={{
                  fontSize: typography.small.fontSize,
                  fontWeight: '500',
                  color: colors.primaryText,
                }}
              >
                {connection.displayInfo.product}
              </span>
            </div>
          </>
        )}

        {connection.healthMessage && (
          <p
            className="p-2 rounded"
            style={{
              fontSize: typography.small.fontSize,
              color: colors.secondaryText,
              backgroundColor: colors.subtleSurface,
            }}
          >
            {connection.healthMessage}
          </p>
        )}

        <div className="flex gap-2 mt-4">
          {connection.connected ? (
            <>
              <AppButton variant="secondary" onClick={onSync} className="flex-1">
                <RefreshCw size={16} className="inline mr-2" />
                Sync
              </AppButton>
              <AppButton variant="outline" onClick={onDisconnect} className="flex-1">
                <Unlink size={16} className="inline mr-2" />
                Disconnect
              </AppButton>
            </>
          ) : (
            <AppButton onClick={onConnect} fullWidth>
              <LinkIcon size={16} className="inline mr-2" />
              Connect Spotify
            </AppButton>
          )}
        </div>
      </div>
    </AppCard>
  );
};
