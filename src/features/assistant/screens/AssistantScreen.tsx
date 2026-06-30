import React, { useState } from 'react';
import { useNavigate } from 'react-router';
import { AppScreen } from '../../../shared/components/AppScreen';
import { AssistantHeader } from '../components/AssistantHeader';
import { MessageBubble } from '../components/MessageBubble';
import { ComposerBar } from '../components/ComposerBar';
import { TypingIndicator } from '../components/TypingIndicator';
import { AssistantMessage } from '../../../shared/utils/mockShapes';

export const AssistantScreen: React.FC = () => {
  const navigate = useNavigate();
  const [messages, setMessages] = useState<AssistantMessage[]>([
    {
      id: '1',
      role: 'assistant',
      content: 'Hi! I\'m ZappBot, your AI financial assistant. How can I help you today?',
      timestamp: new Date().toISOString(),
      quickActions: [
        { id: '1', label: 'Review my spending', action: 'review_spending' },
        { id: '2', label: 'Subscription analysis', action: 'analyze_subscriptions' },
        { id: '3', label: 'Budget advice', action: 'budget_advice' },
      ],
    },
  ]);
  const [isTyping, setIsTyping] = useState(false);

  const handleSend = (content: string) => {
    const userMessage: AssistantMessage = {
      id: Date.now().toString(),
      role: 'user',
      content,
      timestamp: new Date().toISOString(),
    };

    setMessages((prev) => [...prev, userMessage]);
    setIsTyping(true);

    // Simulate AI response
    setTimeout(() => {
      const aiMessage: AssistantMessage = {
        id: (Date.now() + 1).toString(),
        role: 'assistant',
        content: 'I understand you\'re asking about that. Let me analyze your data and get back to you with personalized insights.',
        timestamp: new Date().toISOString(),
        quickActions: [
          { id: '1', label: 'Tell me more', action: 'more_details' },
          { id: '2', label: 'See recommendations', action: 'recommendations' },
        ],
      };
      setMessages((prev) => [...prev, aiMessage]);
      setIsTyping(false);
    }, 1500);
  };

  const handleQuickAction = (action: string) => {
    handleSend(action.replace('_', ' '));
  };

  const handleNewChat = () => {
    setMessages([
      {
        id: '1',
        role: 'assistant',
        content: 'Starting a new conversation. What would you like to discuss?',
        timestamp: new Date().toISOString(),
      },
    ]);
  };

  return (
    <AppScreen padding={false}>
      <AssistantHeader
        onClose={() => navigate(-1)}
        onNewChat={handleNewChat}
      />

      <div className="flex-1 overflow-y-auto px-4 py-6 space-y-4 pb-24">
        {messages.map((message) => (
          <MessageBubble
            key={message.id}
            message={message}
            onQuickAction={handleQuickAction}
          />
        ))}

        {isTyping && <TypingIndicator />}
      </div>

      <ComposerBar onSend={handleSend} disabled={isTyping} />
    </AppScreen>
  );
};
