import React, { useEffect } from 'react';
import { RouterProvider } from 'react-router';
import { AppStateProvider, useAppState } from './providers/AppStateProvider';
import { ThemeProvider } from './providers/ThemeProvider';
import { router } from './routes';
import { AppLoadingState } from '../shared/components/AppLoadingState';
import { AppScreen } from '../shared/components/AppScreen';

const AppContent: React.FC = () => {
  const { state, setLoading, setAuthenticated, setUser } = useAppState();

  useEffect(() => {
    // Simulate auth check
    const checkAuth = async () => {
      // In a real app, this would check for a valid session/token
      await new Promise((resolve) => setTimeout(resolve, 1000));
      
      // For demo purposes, set a mock authenticated user
      // In production, this would check actual auth state
      const isAuthenticated = false; // Set to true to bypass login
      
      if (isAuthenticated) {
        setUser({
          id: '1',
          name: 'Demo User',
          email: 'demo@zapp.app',
          tier: 'Premium',
          mfaEnabled: false,
        });
        setAuthenticated(true);
      }
      
      setLoading(false);
    };

    checkAuth();
  }, [setLoading, setAuthenticated, setUser]);

  if (state.isLoading) {
    return (
      <AppScreen padding={false}>
        <div className="flex items-center justify-center min-h-screen">
          <AppLoadingState message="Loading Zapp..." />
        </div>
      </AppScreen>
    );
  }

  return <RouterProvider router={router} />;
};

const App: React.FC = () => {
  return (
    <AppStateProvider>
      <ThemeProvider>
        <AppContent />
      </ThemeProvider>
    </AppStateProvider>
  );
};

export default App;
