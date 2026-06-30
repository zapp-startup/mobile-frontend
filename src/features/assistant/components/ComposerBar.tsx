import React, { useState } from 'react';
import { Send } from 'lucide-react';
import { colors } from '../../../shared/theme/colors';
import { spacing } from '../../../shared/theme/spacing';
import { radii } from '../../../shared/theme/radii';
import { typography } from '../../../shared/theme/typography';

interface ComposerBarProps {
  onSend: (message: string) => void;
  disabled?: boolean;
}

export const ComposerBar: React.FC<ComposerBarProps> = ({ onSend, disabled = false }) => {
  const [message, setMessage] = useState('');

  const handleSend = () => {
    if (message.trim() && !disabled) {
      onSend(message.trim());
      setMessage('');
    }
  };

  const handleKeyPress = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      handleSend();
    }
  };

  return (
    <div
      className="sticky bottom-0 px-4 py-3"
      style={{
        backgroundColor: colors.appBackground,
        borderTop: `1px solid ${colors.mutedBorder}`,
      }}
    >
      <div className="flex items-end gap-2">
        <textarea
          value={message}
          onChange={(e) => setMessage(e.target.value)}
          onKeyPress={handleKeyPress}
          placeholder="Ask ZappBot anything..."
          disabled={disabled}
          rows={1}
          className="flex-1 resize-none focus:outline-none focus:ring-2 transition-all"
          style={{
            padding: spacing.md,
            backgroundColor: colors.elevatedSurface,
            color: colors.primaryText,
            borderRadius: radii.lg,
            border: `1px solid ${colors.mutedBorder}`,
            fontSize: typography.body.fontSize,
            maxHeight: '120px',
          }}
        />

        <button
          onClick={handleSend}
          disabled={!message.trim() || disabled}
          className="p-3 rounded-lg active:scale-95 transition-all disabled:opacity-50"
          style={{
            backgroundColor: colors.accent,
            color: colors.white,
          }}
        >
          <Send size={20} />
        </button>
      </div>
    </div>
  );
};
