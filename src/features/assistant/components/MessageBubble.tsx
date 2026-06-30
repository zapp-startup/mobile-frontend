import React from 'react';
import { Bot, User } from 'lucide-react';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';
import { radii } from '../../../shared/theme/radii';
import { formatTime } from '../../../shared/utils/formatters';
import { AssistantMessage } from '../../../shared/utils/mockShapes';
import { QuickActionChip } from './QuickActionChip';

interface MessageBubbleProps {
  message: AssistantMessage;
  onQuickAction?: (action: string) => void;
}

export const MessageBubble: React.FC<MessageBubbleProps> = ({ message, onQuickAction }) => {
  const isUser = message.role === 'user';

  return (
    <div className={`flex gap-3 ${isUser ? 'flex-row-reverse' : ''}`}>
      <div
        className="w-8 h-8 rounded-full flex items-center justify-center flex-shrink-0"
        style={{
          backgroundColor: isUser ? colors.accent : colors.elevatedSurface,
        }}
      >
        {isUser ? (
          <User size={16} color={colors.white} />
        ) : (
          <Bot size={16} color={colors.accent} />
        )}
      </div>

      <div className={`flex-1 max-w-[80%] ${isUser ? 'flex flex-col items-end' : ''}`}>
        <div
          className="p-3"
          style={{
            backgroundColor: isUser ? colors.accent : colors.elevatedSurface,
            borderRadius: radii.lg,
            color: isUser ? colors.white : colors.primaryText,
          }}
        >
          <p style={{ fontSize: typography.body.fontSize, lineHeight: '1.5' }}>
            {message.content}
          </p>
        </div>

        <p
          className="mt-1 px-1"
          style={{
            fontSize: typography.caption,
            color: colors.secondaryText,
          }}
        >
          {formatTime(message.timestamp)}
        </p>

        {!isUser && message.quickActions && message.quickActions.length > 0 && (
          <div className="flex flex-wrap gap-2 mt-2">
            {message.quickActions.map((action) => (
              <QuickActionChip
                key={action.id}
                label={action.label}
                onClick={() => onQuickAction?.(action.action)}
              />
            ))}
          </div>
        )}
      </div>
    </div>
  );
};
