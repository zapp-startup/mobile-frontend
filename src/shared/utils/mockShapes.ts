// Mock data shapes for temporary scaffolding
// These structures match the expected backend API contracts

export interface User {
  id: string;
  name: string;
  email: string;
  tier: string;
  mfaEnabled: boolean;
  mfaFactors?: string[];
}

export interface Transaction {
  id: string;
  description: string;
  amount: number;
  type: 'income' | 'expense';
  category: string;
  date: string;
  satisfaction?: number;
  regret?: number;
  repurchase?: number;
  usageFrequency?: string;
  reflection?: string;
  valueScore?: number;
}

export interface BankConnection {
  id: string;
  institutionName: string;
  status: 'connected' | 'disconnected' | 'error' | 'syncing';
  lastSynced?: string;
  accounts: BankAccount[];
}

export interface BankAccount {
  id: string;
  name: string;
  type: string;
  mask: string;
  balance: number;
}

export interface BankTransaction {
  id: string;
  merchant: string;
  amount: number;
  category: string;
  date: string;
  type: 'debit' | 'credit';
  valueScore?: number;
}

export interface Subscription {
  id: string;
  merchant: string;
  amount: number;
  billingCycle: 'monthly' | 'yearly' | 'weekly';
  startedDate: string;
  notes?: string;
  status: 'active' | 'cancelled' | 'paused';
  valueScore?: number;
  valuation?: {
    explanation: string;
    confidence: number;
  };
}

export interface SpotifyConnection {
  connected: boolean;
  status: 'connected' | 'disconnected' | 'syncing' | 'error';
  displayInfo?: {
    accountName: string;
    product: string;
  };
  healthMessage?: string;
  insights?: {
    monthlyListeningHours: number;
    topGenre: string;
  };
}

export interface Circle {
  id: string;
  name: string;
  memberCount: number;
  isPrivate: boolean;
  inviteCode?: string;
  rank?: number;
  members?: CircleMember[];
  leaderboard?: LeaderboardEntry[];
}

export interface CircleMember {
  id: string;
  name: string;
  joinedDate: string;
  role: 'admin' | 'member';
}

export interface LeaderboardEntry {
  userId: string;
  userName: string;
  score: number;
  rank: number;
}

export interface Badge {
  id: string;
  name: string;
  description: string;
  unlockedDate?: string;
  isLocked: boolean;
  iconUrl?: string;
}

export interface Target {
  id: string;
  title: string;
  type: 'savings' | 'spending' | 'income';
  targetValue: number;
  currentValue: number;
  progress: number;
}

export interface Review {
  id: string;
  type: 'weekly' | 'monthly';
  reviewedCount: number;
  pendingCount: number;
  prompts: ReviewPrompt[];
}

export interface ReviewPrompt {
  id: string;
  question: string;
  answer?: string;
}

export interface AssistantMessage {
  id: string;
  role: 'user' | 'assistant';
  content: string;
  timestamp: string;
  quickActions?: QuickAction[];
}

export interface QuickAction {
  id: string;
  label: string;
  action: string;
}

export interface AnalyticsMetric {
  id: string;
  name: string;
  value: string | number;
  change?: number;
}

export interface FinancialProfile {
  lifeStage?: string;
  householdSize?: number;
  zipCode?: string;
  incomeRange?: string;
  monthlyFixedExpenses?: number;
  financialGoal?: string;
  riskTolerance?: string;
  budgetStyle?: string;
  priorities?: {
    cost: number;
    quality: number;
    sustainability: number;
  };
  researchHabit?: string;
}

export interface Preference {
  id: string;
  category: string;
  value: string;
}
