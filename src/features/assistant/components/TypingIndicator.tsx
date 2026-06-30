import React from 'react';
import { Bot } from 'lucide-react';
import { colors } from '../../../shared/theme/colors';
import { radii } from '../../../shared/theme/radii';

export const TypingIndicator: React.FC = () => {
  return (
    <div className="flex gap-3">
      <div
        className="w-8 h-8 rounded-full flex items-center justify-center flex-shrink-0"
        style={{ backgroundColor: colors.elevatedSurface }}
      >
        <Bot size={16} color={colors.accent} />
      </div>

      <div
        className="p-3"
        style={{
          backgroundColor: colors.elevatedSurface,
          borderRadius: radii.lg,
        }}
      >
        <div className="flex gap-1">
          {[0, 1, 2].map((i) => (
            <div
              key={i}
              className="w-2 h-2 rounded-full animate-bounce"
              style={{
                backgroundColor: colors.secondaryText,
                animationDelay: `${i * 0.15}s`,
              }}
            />
          ))}
        </div>
      </div>
    </div>
  );
};
