import { createBrowserRouter } from 'react-router';

// Auth
import { LoginScreen } from '../features/auth/screens/LoginScreen';
import { SignUpScreen } from '../features/auth/screens/SignUpScreen';
import { AuthCallbackScreen } from '../features/auth/screens/AuthCallbackScreen';
import { MfaSetupScreen } from '../features/auth/screens/MfaSetupScreen';
import { MfaVerifyScreen } from '../features/auth/screens/MfaVerifyScreen';

// Onboarding
import { OnboardingScreen } from '../features/onboarding/screens/OnboardingScreen';

// Home
import { HomeScreen } from '../features/home/screens/HomeScreen';
import { AnalyticsSummaryScreen } from '../features/home/screens/AnalyticsSummaryScreen';

// Transactions
import { TransactionsScreen } from '../features/transactions/screens/TransactionsScreen';
import { TransactionDetailScreen } from '../features/transactions/screens/TransactionDetailScreen';
import { TransactionFormScreen } from '../features/transactions/screens/TransactionFormScreen';
import { BankingConnectionsScreen } from '../features/transactions/screens/BankingConnectionsScreen';
import { BankConnectionDetailScreen } from '../features/transactions/screens/BankConnectionDetailScreen';
import { BankTransactionsScreen } from '../features/transactions/screens/BankTransactionsScreen';

// Subscriptions
import { SubscriptionsScreen } from '../features/subscriptions/screens/SubscriptionsScreen';
import { SubscriptionDetailScreen } from '../features/subscriptions/screens/SubscriptionDetailScreen';
import { SubscriptionFormScreen } from '../features/subscriptions/screens/SubscriptionFormScreen';
import { SpotifyCallbackScreen } from '../features/subscriptions/screens/SpotifyCallbackScreen';

// Circles
import { CirclesScreen } from '../features/circles/screens/CirclesScreen';
import { CircleDetailScreen } from '../features/circles/screens/CircleDetailScreen';
import { BadgesScreen } from '../features/circles/screens/BadgesScreen';
import { TargetsScreen } from '../features/circles/screens/TargetsScreen';
import { WeeklyReviewScreen } from '../features/circles/screens/WeeklyReviewScreen';
import { MonthlyReviewScreen } from '../features/circles/screens/MonthlyReviewScreen';

// Analytics
import { AnalyticsScreen } from '../features/analytics/screens/AnalyticsScreen';

// Assistant
import { AssistantScreen } from '../features/assistant/screens/AssistantScreen';

// Profile
import { ProfileScreen } from '../features/profile/screens/ProfileScreen';
import { SearchScreen } from '../features/profile/screens/SearchScreen';
import { PrivacyPolicyScreen } from '../features/profile/screens/PrivacyPolicyScreen';

// Main layout with tab bar
import { MainLayout } from './layouts/MainLayout';

export const router = createBrowserRouter([
  // Auth routes (no tab bar)
  {
    path: '/login',
    element: <LoginScreen />,
  },
  {
    path: '/signup',
    element: <SignUpScreen />,
  },
  {
    path: '/auth/callback',
    element: <AuthCallbackScreen />,
  },
  {
    path: '/mfa-setup',
    element: <MfaSetupScreen />,
  },
  {
    path: '/mfa-verify',
    element: <MfaVerifyScreen />,
  },

  // Onboarding (no tab bar)
  {
    path: '/onboarding',
    element: <OnboardingScreen />,
  },

  // Main app routes (with tab bar)
  {
    element: <MainLayout />,
    children: [
      // Home tab
      {
        path: '/',
        element: <HomeScreen />,
      },
      {
        path: '/analytics-summary',
        element: <AnalyticsSummaryScreen />,
      },

      // Transactions tab
      {
        path: '/transactions',
        element: <TransactionsScreen />,
      },
      {
        path: '/transactions/new',
        element: <TransactionFormScreen />,
      },
      {
        path: '/transactions/:id',
        element: <TransactionDetailScreen />,
      },
      {
        path: '/transactions/:id/edit',
        element: <TransactionFormScreen />,
      },
      {
        path: '/transactions/banking',
        element: <BankingConnectionsScreen />,
      },
      {
        path: '/transactions/banking/:id',
        element: <BankConnectionDetailScreen />,
      },
      {
        path: '/transactions/banking/:id/transactions',
        element: <BankTransactionsScreen />,
      },

      // Subscriptions tab
      {
        path: '/subscriptions',
        element: <SubscriptionsScreen />,
      },
      {
        path: '/subscriptions/new',
        element: <SubscriptionFormScreen />,
      },
      {
        path: '/subscriptions/:id',
        element: <SubscriptionDetailScreen />,
      },
      {
        path: '/subscriptions/:id/edit',
        element: <SubscriptionFormScreen />,
      },
      {
        path: '/subscriptions/spotify-callback',
        element: <SpotifyCallbackScreen />,
      },

      // Circles tab
      {
        path: '/circles',
        element: <CirclesScreen />,
      },
      {
        path: '/circles/:id',
        element: <CircleDetailScreen />,
      },
      {
        path: '/badges',
        element: <BadgesScreen />,
      },
      {
        path: '/targets',
        element: <TargetsScreen />,
      },
      {
        path: '/weekly-review',
        element: <WeeklyReviewScreen />,
      },
      {
        path: '/monthly-review',
        element: <MonthlyReviewScreen />,
      },

      // Profile tab
      {
        path: '/profile',
        element: <ProfileScreen />,
      },
    ],
  },

  // Full-screen routes (no tab bar)
  {
    path: '/analytics',
    element: <AnalyticsScreen />,
  },
  {
    path: '/assistant',
    element: <AssistantScreen />,
  },
  {
    path: '/search',
    element: <SearchScreen />,
  },
  {
    path: '/privacy',
    element: <PrivacyPolicyScreen />,
  },
]);
