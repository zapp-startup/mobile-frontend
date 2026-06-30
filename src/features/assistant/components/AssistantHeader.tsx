import React from 'react';
import { X, Plus } from 'lucide-react';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';

interface AssistantHeaderProps {
  onClose: () => void;
  onNewChat: () => void;
}

export const AssistantHeader: React.FC<AssistantHeaderProps> = ({ onClose, onNewChat }) => {
  return (
    <div
      className="sticky top-0 z-40 flex items-center justify-between px-4 py-4"
      style={{
        backgroundColor: colors.appBackground,
        borderBottom: `1px solid ${colors.mutedBorder}`,
      }}
    >
      <h1
        style={{
          fontSize: typography.sectionTitle.fontSize,
          fontWeight: typography.sectionTitle.fontWeight,
          color: colors.primaryText,
        }}
      >
        ZappBot Assistant
      </h1>

      <div className="flex items-center gap-2">
        <button
          onClick={onNewChat}
          className="p-2 rounded-lg active:opacity-70 transition-opacity"
          style={{ color: colors.accent }}
        >
          <Plus size={20} />
        </button>
        <button
          onClick={onClose}
          className="p-2 rounded-lg active:opacity-70 transition-opacity"
          style={{ color: colors.primaryText }}
        >
          <X size={20} />
        </button>
      </div>
    </div>
  );
};
