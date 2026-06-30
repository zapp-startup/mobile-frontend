import React from 'react';
import { X } from 'lucide-react';
import { colors } from '../theme/colors';
import { spacing } from '../theme/spacing';
import { radii } from '../theme/radii';
import { typography } from '../theme/typography';

interface AppSheetProps {
  isOpen: boolean;
  onClose: () => void;
  title?: string;
  children: React.ReactNode;
  className?: string;
}

export const AppSheet: React.FC<AppSheetProps> = ({
  isOpen,
  onClose,
  title,
  children,
  className = '',
}) => {
  if (!isOpen) return null;

  return (
    <>
      {/* Backdrop */}
      <div
        className="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm"
        onClick={onClose}
      />
      
      {/* Sheet */}
      <div
        className={`fixed bottom-0 left-0 right-0 z-50 max-h-[90vh] overflow-y-auto ${className}`}
        style={{
          backgroundColor: colors.elevatedSurface,
          borderTopLeftRadius: radii['2xl'],
          borderTopRightRadius: radii['2xl'],
          padding: spacing.sheetPadding,
        }}
      >
        {/* Handle */}
        <div className="flex justify-center mb-4">
          <div
            className="w-12 h-1 rounded-full"
            style={{ backgroundColor: colors.mutedBorder }}
          />
        </div>

        {/* Header */}
        {title && (
          <div className="flex items-center justify-between mb-4">
            <h2
              style={{
                fontSize: typography.sectionTitle.fontSize,
                fontWeight: typography.sectionTitle.fontWeight,
                color: colors.primaryText,
              }}
            >
              {title}
            </h2>
            <button
              onClick={onClose}
              className="p-2 rounded-lg active:opacity-70 transition-opacity"
              style={{ color: colors.secondaryText }}
            >
              <X size={20} />
            </button>
          </div>
        )}

        {/* Content */}
        {children}
      </div>
    </>
  );
};
