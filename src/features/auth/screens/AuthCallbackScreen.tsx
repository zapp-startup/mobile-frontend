import React, { useEffect } from 'react';
import { useNavigate } from 'react-router';
import { AppScreen } from '../../../shared/components/AppScreen';
import { AppLoadingState } from '../../../shared/components/AppLoadingState';

export const AuthCallbackScreen: React.FC = () => {
  const navigate = useNavigate();

  useEffect(() => {
    // Simulate OAuth callback processing
    const timer = setTimeout(() => {
      navigate('/');
    }, 2000);

    return () => clearTimeout(timer);
  }, [navigate]);

  return (
    <AppScreen padding={false}>
      <div className="flex items-center justify-center min-h-screen">
        <AppLoadingState message="Signing you in..." />
      </div>
    </AppScreen>
  );
};
