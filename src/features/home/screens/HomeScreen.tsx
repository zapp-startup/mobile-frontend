import React from 'react';
import { useNavigate } from 'react-router';
import { Search, MessageCircle, BarChart3, AlertCircle, Zap, Camera } from 'lucide-react';
import { AppScreen } from '../../../shared/components/AppScreen';
import { AppHeader } from '../../../shared/components/AppHeader';
import { DashboardHeroCard } from '../components/DashboardHeroCard';
import { KpiCard } from '../components/KpiCard';
import { CategoryBreakdownCard } from '../components/CategoryBreakdownCard';
import { RecentTransactionCard } from '../components/RecentTransactionCard';
import { GamificationStrip } from '../components/GamificationStrip';
import { InsightCard } from '../components/InsightCard';
import { colors } from '../../../shared/theme/colors';

export const HomeScreen: React.FC = () => {
  const navigate = useNavigate();

  // Mock data
  const mockTransactions = [
    { id: '1', description: 'Whole Foods', amount: -67.42, type: 'expense' as const, category: 'Groceries', date: '2026-04-14' },
    { id: '2', description: 'Salary Deposit', amount: 5000, type: 'income' as const, category: 'Income', date: '2026-04-13' },
    { id: '3', description: 'Netflix', amount: -15.99, type: 'expense' as const, category: 'Subscriptions', date: '2026-04-12' },
    { id: '4', description: 'Uber', amount: -23.15, type: 'expense' as const, category: 'Transportation', date: '2026-04-11' },
  ];

  const mockCategories = [
    { name: 'Groceries', amount: 450, percentage: 35, color: colors.accent },
    { name: 'Dining', amount: 320, percentage: 25, color: colors.warning },
    { name: 'Transportation', amount: 200, percentage: 15, color: colors.success },
    { name: 'Entertainment', amount: 150, percentage: 12, color: colors.error },
    { name: 'Other', amount: 180, percentage: 13, color: colors.secondaryText },
  ];

  return (
    <AppScreen>
      <AppHeader
        title="Home"
        rightActions={
          <div className="flex items-center gap-2">
            <button
              onClick={() => navigate('/search')}
              className="p-2 rounded-lg active:opacity-70 transition-opacity"
              style={{ color: colors.primaryText }}
            >
              <Search size={20} />
            </button>
            <button
              onClick={() => navigate('/assistant')}
              className="p-2 rounded-lg active:opacity-70 transition-opacity"
              style={{ color: colors.primaryText }}
            >
              <MessageCircle size={20} />
            </button>
            <button
              onClick={() => navigate('/analytics')}
              className="p-2 rounded-lg active:opacity-70 transition-opacity"
              style={{ color: colors.primaryText }}
            >
              <BarChart3 size={20} />
            </button>
          </div>
        }
      />

      <div className="px-4 py-6 space-y-4">
        <GamificationStrip
          streak={12}
          badges={8}
          targetsCompleted={3}
          onClick={() => navigate('/circles')}
        />

        <DashboardHeroCard
          totalValue={12450.75}
          trend={8.3}
          valueScore={78}
        />

        <div className="grid grid-cols-2 gap-3">
          <KpiCard
            icon={Zap}
            label="Daily Streak"
            value="12 days"
            subtitle="Keep it up!"
          />
          <KpiCard
            icon={AlertCircle}
            label="Health Score"
            value="Good"
            subtitle="2 alerts"
          />
        </div>

        <CategoryBreakdownCard
          categories={mockCategories}
          onViewAll={() => navigate('/analytics')}
        />

        <RecentTransactionCard
          transactions={mockTransactions}
          onViewAll={() => navigate('/transactions')}
        />

        <InsightCard
          title="Great savings this month!"
          description="You've saved 15% more than last month. Keep up the momentum to reach your goals faster."
          actionLabel="View Details"
          onAction={() => navigate('/analytics')}
        />

        <div
          className="flex items-center justify-center gap-2 p-4 rounded-xl active:opacity-80 transition-opacity"
          style={{
            backgroundColor: colors.elevatedSurface,
            border: `1px dashed ${colors.accent}`,
          }}
          onClick={() => navigate('/buy-advisor')}
        >
          <Camera size={20} color={colors.accent} />
          <span style={{ color: colors.accent, fontWeight: '500' }}>
            Scan Purchase with Buy Advisor
          </span>
        </div>
      </div>
    </AppScreen>
  );
};
