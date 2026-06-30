import React, { useState } from 'react';
import { useNavigate } from 'react-router';
import { AppScreen } from '../../../shared/components/AppScreen';
import { AppInput } from '../../../shared/components/AppInput';
import { AppButton } from '../../../shared/components/AppButton';
import { AuthCard } from '../components/AuthCard';
import { SocialAuthButton } from '../components/SocialAuthButton';
import { colors } from '../../../shared/theme/colors';
import { spacing } from '../../../shared/theme/spacing';
import { typography } from '../../../shared/theme/typography';
import { useAppState } from '../../../app/providers/AppStateProvider';

export const LoginScreen: React.FC = () => {
  const navigate = useNavigate();
  const { setUser, setAuthenticated } = useAppState();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleLogin = async () => {
    setError('');
    setLoading(true);

    // Simulate API call
    setTimeout(() => {
      if (email && password) {
        // Mock successful login
        setUser({
          id: '1',
          name: 'Demo User',
          email: email,
          tier: 'Premium',
          mfaEnabled: false,
        });
        setAuthenticated(true);
        navigate('/');
      } else {
        setError('Please enter email and password');
      }
      setLoading(false);
    }, 1000);
  };

  const handleGoogleAuth = () => {
    // Simulate Google OAuth flow
    console.log('Google auth initiated');
  };

  return (
    <AppScreen padding={false}>
      <div className="flex flex-col justify-center min-h-screen py-8">
        {/* Logo */}
        <div className="text-center mb-8">
          <h1
            style={{
              fontSize: '3rem',
              fontWeight: '700',
              color: colors.accent,
              textShadow: `0 0 30px ${colors.accentGlow}`,
            }}
          >
            Zapp
          </h1>
        </div>

        <AuthCard title="Welcome back" subtitle="Enter your credentials to continue">
          <div className="space-y-4">
            <SocialAuthButton provider="google" onClick={handleGoogleAuth} />

            <div className="flex items-center gap-4 my-6">
              <div
                className="flex-1 h-px"
                style={{ backgroundColor: colors.mutedBorder }}
              />
              <span style={{ color: colors.secondaryText, fontSize: typography.small.fontSize }}>
                or
              </span>
              <div
                className="flex-1 h-px"
                style={{ backgroundColor: colors.mutedBorder }}
              />
            </div>

            <AppInput
              label="Email"
              type="email"
              value={email}
              onChange={setEmail}
              placeholder="you@example.com"
            />

            <AppInput
              label="Password"
              type="password"
              value={password}
              onChange={setPassword}
              placeholder="••••••••"
            />

            {error && (
              <p style={{ color: colors.error, fontSize: typography.small.fontSize }}>
                {error}
              </p>
            )}

            <AppButton fullWidth onClick={handleLogin} loading={loading}>
              Sign in
            </AppButton>

            <div className="text-center mt-4">
              <span style={{ color: colors.secondaryText, fontSize: typography.small.fontSize }}>
                Don't have an account?{' '}
              </span>
              <button
                onClick={() => navigate('/signup')}
                style={{ color: colors.accent, fontSize: typography.small.fontSize }}
                className="font-semibold"
              >
                Sign up
              </button>
            </div>

            <div className="text-center mt-4">
              <p style={{ color: colors.secondaryText, fontSize: typography.caption }}>
                By signing in, you agree to our Terms and Privacy Policy
              </p>
            </div>
          </div>
        </AuthCard>
      </div>
    </AppScreen>
  );
};
