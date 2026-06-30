import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router';
import { Search, BarChart3, FileText, LogOut } from 'lucide-react';
import { AppScreen } from '../../../shared/components/AppScreen';
import { AppHeader } from '../../../shared/components/AppHeader';
import { ProfileIdentityCard } from '../components/ProfileIdentityCard';
import { FinancialProfileCard } from '../components/FinancialProfileCard';
import { PreferencesList } from '../components/PreferencesList';
import { MfaEnrollmentCard } from '../components/MfaEnrollmentCard';
import { SettingsRow } from '../components/SettingsRow';
import { SectionHeader } from '../../../shared/components/SectionHeader';
import { useAppState } from '../../../app/providers/AppStateProvider';

export const ProfileScreen: React.FC = () => {
  const navigate = useNavigate();
  const { state, logout } = useAppState();
  const [preferences, setPreferences] = useState([
    { id: '1', category: 'Food', value: 'Organic' },
    { id: '2', category: 'Transport', value: 'Eco-friendly' },
  ]);

  // Redirect to login if not authenticated
  useEffect(() => {
    if (!state.user) {
      navigate('/login');
    }
  }, [state.user, navigate]);

  const handleAddPreference = (category: string, value: string) => {
    setPreferences([...preferences, { id: Date.now().toString(), category, value }]);
  };

  const handleRemovePreference = (id: string) => {
    setPreferences(preferences.filter((p) => p.id !== id));
  };

  const handleLogout = () => {
    logout();
    navigate('/login');
  };

  if (!state.user) {
    return null;
  }

  return (
    <AppScreen>
      <AppHeader title="Profile" />

      <div className="px-4 py-6 space-y-4">
        <ProfileIdentityCard user={state.user} />

        <FinancialProfileCard
          profile={{
            lifeStage: 'early-career',
            householdSize: 2,
            zipCode: '10001',
            incomeRange: '60-100k',
          }}
          onSave={(profile) => console.log('Save profile:', profile)}
        />

        <PreferencesList
          preferences={preferences}
          onAdd={handleAddPreference}
          onRemove={handleRemovePreference}
        />

        <MfaEnrollmentCard
          mfaEnabled={state.user.mfaEnabled || false}
          onSetup={() => navigate('/mfa-setup')}
          onManage={() => navigate('/mfa-setup')}
        />

        <SectionHeader title="Settings" />

        <div className="space-y-2">
          <SettingsRow
            icon={BarChart3}
            label="Analytics"
            onClick={() => navigate('/analytics')}
          />

          <SettingsRow
            icon={Search}
            label="Search"
            onClick={() => navigate('/search')}
          />

          <SettingsRow
            icon={FileText}
            label="Privacy Policy"
            onClick={() => navigate('/privacy')}
          />

          <SettingsRow
            icon={LogOut}
            label="Logout"
            onClick={handleLogout}
            variant="danger"
          />
        </div>
      </div>
    </AppScreen>
  );
};