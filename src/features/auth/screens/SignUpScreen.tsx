import React, { useState } from 'react';
import { useNavigate } from 'react-router';
import { AppScreen } from '../../../shared/components/AppScreen';
import { AppInput } from '../../../shared/components/AppInput';
import { AppButton } from '../../../shared/components/AppButton';
import { AuthCard } from '../components/AuthCard';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';

export const SignUpScreen: React.FC = () => {
  const navigate = useNavigate();
  const [fullName, setFullName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [loading, setLoading] = useState(false);

  const handleSignUp = async () => {
    const newErrors: Record<string, string> = {};

    if (!fullName) newErrors.fullName = 'Full name is required';
    if (!email) newErrors.email = 'Email is required';
    if (!password) newErrors.password = 'Password is required';
    if (password !== confirmPassword) newErrors.confirmPassword = 'Passwords do not match';

    if (Object.keys(newErrors).length > 0) {
      setErrors(newErrors);
      return;
    }

    setErrors({});
    setLoading(true);

    // Simulate API call
    setTimeout(() => {
      navigate('/onboarding');
      setLoading(false);
    }, 1000);
  };

  return (
    <AppScreen padding={false}>
      <div className="flex flex-col justify-center min-h-screen py-8">
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

        <AuthCard title="Create your account" subtitle="Start your financial journey with Zapp">
          <div className="space-y-4">
            <AppInput
              label="Full Name"
              value={fullName}
              onChange={setFullName}
              placeholder="John Doe"
              error={errors.fullName}
              required
            />

            <AppInput
              label="Email"
              type="email"
              value={email}
              onChange={setEmail}
              placeholder="you@example.com"
              error={errors.email}
              required
            />

            <AppInput
              label="Password"
              type="password"
              value={password}
              onChange={setPassword}
              placeholder="••••••••"
              error={errors.password}
              required
            />

            <AppInput
              label="Confirm Password"
              type="password"
              value={confirmPassword}
              onChange={setConfirmPassword}
              placeholder="••••••••"
              error={errors.confirmPassword}
              required
            />

            <AppButton fullWidth onClick={handleSignUp} loading={loading}>
              Sign up
            </AppButton>

            <div className="text-center mt-4">
              <span style={{ color: colors.secondaryText, fontSize: typography.small.fontSize }}>
                Already have an account?{' '}
              </span>
              <button
                onClick={() => navigate('/login')}
                style={{ color: colors.accent, fontSize: typography.small.fontSize }}
                className="font-semibold"
              >
                Sign in
              </button>
            </div>

            <div className="text-center mt-4">
              <p style={{ color: colors.secondaryText, fontSize: typography.caption }}>
                By signing up, you agree to our Terms and Privacy Policy
              </p>
            </div>
          </div>
        </AuthCard>
      </div>
    </AppScreen>
  );
};
