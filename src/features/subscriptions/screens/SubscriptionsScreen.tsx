import React, { useState } from 'react';
import { useNavigate } from 'react-router';
import { Plus } from 'lucide-react';
import { AppScreen } from '../../../shared/components/AppScreen';
import { AppHeader } from '../../../shared/components/AppHeader';
import { AppEmptyState } from '../../../shared/components/AppEmptyState';
import { SubscriptionCard } from '../components/SubscriptionCard';
import { SpotifyIntegrationCard } from '../components/SpotifyIntegrationCard';
import { SpotifyInsightsCard } from '../components/SpotifyInsightsCard';
import { SectionHeader } from '../../../shared/components/SectionHeader';
import { Subscription } from '../../../shared/utils/mockShapes';
import { colors } from '../../../shared/theme/colors';

export const SubscriptionsScreen: React.FC = () => {
  const navigate = useNavigate();
  const [spotifyConnection, setSpotifyConnection] = useState({
    connected: true,
    status: 'connected' as const,
    displayInfo: {
      accountName: 'user@example.com',
      product: 'Premium',
    },
    healthMessage: 'Last synced 2 hours ago',
    insights: {
      monthlyListeningHours: 45,
      topGenre: 'Indie Rock',
    },
  });

  const mockSubscriptions: Subscription[] = [
    {
      id: '1',
      merchant: 'Netflix',
      amount: 15.99,
      billingCycle: 'monthly',
      startedDate: '2023-01-15',
      status: 'active',
      valueScore: 85,
      valuation: {
        explanation: 'High value based on frequent usage and content variety',
        confidence: 92,
      },
    },
    {
      id: '2',
      merchant: 'Spotify',
      amount: 10.99,
      billingCycle: 'monthly',
      startedDate: '2022-06-01',
      status: 'active',
      valueScore: 90,
      notes: 'Family plan',
      valuation: {
        explanation: 'Excellent value for daily usage',
        confidence: 95,
      },
    },
    {
      id: '3',
      merchant: 'Adobe Creative Cloud',
      amount: 54.99,
      billingCycle: 'monthly',
      startedDate: '2024-03-01',
      status: 'active',
      valueScore: 75,
    },
  ];

  const handleSpotifyConnect = () => {
    navigate('/subscriptions/spotify-callback');
  };

  return (
    <AppScreen>
      <AppHeader
        title="Subscriptions"
        rightActions={
          <button
            onClick={() => navigate('/subscriptions/new')}
            className="p-2 rounded-lg active:opacity-70 transition-opacity"
            style={{ color: colors.accent }}
          >
            <Plus size={20} />
          </button>
        }
      />

      <div className="px-4 py-6 space-y-4">
        <SpotifyIntegrationCard
          connection={spotifyConnection}
          onConnect={handleSpotifyConnect}
          onSync={() => console.log('Syncing Spotify...')}
          onDisconnect={() => setSpotifyConnection({ ...spotifyConnection, connected: false, status: 'disconnected' })}
        />

        {spotifyConnection.connected && spotifyConnection.insights && (
          <SpotifyInsightsCard insights={spotifyConnection.insights} />
        )}

        {mockSubscriptions.length > 0 ? (
          <>
            <SectionHeader title="Your Subscriptions" subtitle={`${mockSubscriptions.length} active`} />
            <div className="space-y-3">
              {mockSubscriptions.map((sub) => (
                <SubscriptionCard
                  key={sub.id}
                  subscription={sub}
                  onClick={() => navigate(`/subscriptions/${sub.id}`)}
                />
              ))}
            </div>
          </>
        ) : (
          <AppEmptyState
            title="No subscriptions"
            description="Add your first subscription to start tracking"
            actionLabel="Add Subscription"
            onAction={() => navigate('/subscriptions/new')}
          />
        )}
      </div>
    </AppScreen>
  );
};
