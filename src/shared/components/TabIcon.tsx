import React from 'react';
import { Home, Receipt, CreditCard, Users, User } from 'lucide-react';
import { colors } from '../theme/colors';

interface TabIconProps {
  name: 'home' | 'transactions' | 'subscriptions' | 'circles' | 'profile';
  active: boolean;
  size?: number;
}

export const TabIcon: React.FC<TabIconProps> = ({ 
  name, 
  active,
  size = 24,
}) => {
  const iconMap = {
    home: Home,
    transactions: Receipt,
    subscriptions: CreditCard,
    circles: Users,
    profile: User,
  };

  const Icon = iconMap[name];
  const color = active ? colors.accent : colors.secondaryText;

  return <Icon size={size} color={color} />;
};
