import React, { createContext, useContext, useState, ReactNode } from 'react';
import { User } from '../../shared/utils/mockShapes';

interface AppState {
  user: User | null;
  isAuthenticated: boolean;
  isLoading: boolean;
}

interface AppStateContextValue {
  state: AppState;
  setUser: (user: User | null) => void;
  setAuthenticated: (value: boolean) => void;
  setLoading: (value: boolean) => void;
  logout: () => void;
}

const AppStateContext = createContext<AppStateContextValue | undefined>(undefined);

export const AppStateProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
  const [state, setState] = useState<AppState>({
    user: null,
    isAuthenticated: false,
    isLoading: true,
  });

  const setUser = (user: User | null) => {
    setState((prev) => ({ ...prev, user }));
  };

  const setAuthenticated = (value: boolean) => {
    setState((prev) => ({ ...prev, isAuthenticated: value }));
  };

  const setLoading = (value: boolean) => {
    setState((prev) => ({ ...prev, isLoading: value }));
  };

  const logout = () => {
    setState({
      user: null,
      isAuthenticated: false,
      isLoading: false,
    });
  };

  return (
    <AppStateContext.Provider
      value={{
        state,
        setUser,
        setAuthenticated,
        setLoading,
        logout,
      }}
    >
      {children}
    </AppStateContext.Provider>
  );
};

export const useAppState = () => {
  const context = useContext(AppStateContext);
  if (!context) {
    throw new Error('useAppState must be used within AppStateProvider');
  }
  return context;
};
