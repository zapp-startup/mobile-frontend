import React, { useState } from 'react';
import { Plus, X } from 'lucide-react';
import { AppCard } from '../../../shared/components/AppCard';
import { SectionHeader } from '../../../shared/components/SectionHeader';
import { AddPreferenceSheet } from './AddPreferenceSheet';
import { Preference } from '../../../shared/utils/mockShapes';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';
import { radii } from '../../../shared/theme/radii';

interface PreferencesListProps {
  preferences: Preference[];
  onAdd: (preference: Omit<Preference, 'id'>) => void;
  onRemove: (id: string) => void;
}

export const PreferencesList: React.FC<PreferencesListProps> = ({
  preferences,
  onAdd,
  onRemove,
}) => {
  const [sheetOpen, setSheetOpen] = useState(false);

  return (
    <>
      <AppCard>
        <SectionHeader
          title="Preferences"
          subtitle="Your spending priorities"
          action={
            <button
              onClick={() => setSheetOpen(true)}
              className="p-2 rounded-lg active:opacity-70 transition-opacity"
              style={{ color: colors.accent }}
            >
              <Plus size={20} />
            </button>
          }
        />

        {preferences.length > 0 ? (
          <div className="space-y-2 mt-4">
            {preferences.map((pref) => (
              <div
                key={pref.id}
                className="flex items-center justify-between p-3"
                style={{
                  backgroundColor: colors.subtleSurface,
                  borderRadius: radii.lg,
                }}
              >
                <div>
                  <p
                    style={{
                      fontSize: typography.body.fontSize,
                      fontWeight: '500',
                      color: colors.primaryText,
                    }}
                  >
                    {pref.category}
                  </p>
                  <p
                    style={{
                      fontSize: typography.small.fontSize,
                      color: colors.secondaryText,
                    }}
                  >
                    {pref.value}
                  </p>
                </div>

                <button
                  onClick={() => onRemove(pref.id)}
                  className="p-1 rounded active:opacity-70"
                  style={{ color: colors.error }}
                >
                  <X size={16} />
                </button>
              </div>
            ))}
          </div>
        ) : (
          <p
            className="text-center py-4"
            style={{
              fontSize: typography.small.fontSize,
              color: colors.secondaryText,
            }}
          >
            No preferences added yet
          </p>
        )}
      </AppCard>

      <AddPreferenceSheet
        isOpen={sheetOpen}
        onClose={() => setSheetOpen(false)}
        onAdd={(category, value) => {
          onAdd({ category, value });
          setSheetOpen(false);
        }}
      />
    </>
  );
};
