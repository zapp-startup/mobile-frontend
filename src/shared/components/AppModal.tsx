import React from 'react';
import { X } from 'lucide-react';
import { colors } from '../theme/colors';
import { spacing } from '../theme/spacing';
import { radii } from '../theme/radii';
import { typography } from '../theme/typography';

interface AppModalProps {
  isOpen: boolean;
  onClose: () => void;
  title?: string;
  children: React.ReactNode;
  size?: 'sm' | 'md' | 'lg';
  className?: string;
}

export const AppModal: React.FC<AppModalProps> = ({
  isOpen,
  onClose,
  title,
  children,
  size = 'md',
  className = '',
}) => {
  if (!isOpen) return null;

  const sizeStyles = {
    sm: 'max-w-sm',
    md: 'max-w-md',
    lg: 'max-w-lg',
  }[size];

  return (
    <>
      {/* Backdrop */}
      <div
        className="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4"
        onClick={onClose}
      >
        {/* Modal */}
        <div
          className={`w-full ${sizeStyles} ${className}`}
          onClick={(e) => e.stopPropagation()}
          style={{
            backgroundColor: colors.elevatedSurface,
            borderRadius: radii.xl,
            padding: spacing.cardPaddingLg,
            border: `1px solid ${colors.mutedBorder}`,
          }}
        >
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
      </div>
    </>
  );
};
