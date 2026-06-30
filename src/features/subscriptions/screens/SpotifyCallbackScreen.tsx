import React, { useEffect } from 'react';
import { useNavigate } from 'react-router';
import { AppScreen } from '../../../shared/components/AppScreen';
import { AppLoadingState } from '../../../shared/components/AppLoadingState';

export const SpotifyCallbackScreen: React.FC = () => {
  const navigate = useNavigate();

  useEffect(() => {
    // Simulate Spotify OAuth callback processing
    const timer = setTimeout(() => {
      navigate('/subscriptions');
    }, 2000);

    return () => clearTimeout(timer);
  }, [navigate]);

  return (
    <AppScreen padding={false}>
      <div className="flex items-center justify-center min-h-screen">
        <AppLoadingState message="Connecting to Spotify..." />
      </div>
    </AppScreen>
  );
};
