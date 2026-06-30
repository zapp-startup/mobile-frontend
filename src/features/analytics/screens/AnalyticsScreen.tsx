import React from 'react';
import { Layers, TrendingUp, Eye } from 'lucide-react';
import { AppScreen } from '../../../shared/components/AppScreen';
import { AppHeader } from '../../../shared/components/AppHeader';
import { AnalyticsMetricCard } from '../components/AnalyticsMetricCard';
import { ValuationInputCard } from '../components/ValuationInputCard';
import { InsightsListSection } from '../components/InsightsListSection';
import { MetricDrilldownCard } from '../components/MetricDrilldownCard';

export const AnalyticsScreen: React.FC = () => {
  const insights = [
    {
      id: '1',
      title: 'Subscription Overlap Detected',
      description: 'You have 3 music streaming services. Consider consolidating to save $20/month.',
    },
    {
      id: '2',
      title: 'High Value Purchases',
      description: 'Your recent grocery purchases have high value scores. Keep it up!',
    },
  ];

  const computedOutputs = [
    { label: 'Value Score', value: '78' },
    { label: 'Predicted Satisfaction', value: '85%' },
    { label: 'Regret Likelihood', value: 'Low' },
  ];

  const rawValues = [
    { label: 'Cost per Use', value: '$2.50' },
    { label: 'Market Price', value: '$45.99' },
    { label: 'Quality Score', value: '8.5/10' },
  ];

  return (
    <AppScreen>
      <AppHeader title="Analytics" showBack />

      <div className="px-4 py-6 space-y-4">
        <div className="grid grid-cols-1 gap-3">
          <AnalyticsMetricCard
            icon={Layers}
            title="Tracked Stacks"
            value="3"
            subtitle="Subscription bundles"
          />

          <AnalyticsMetricCard
            icon={TrendingUp}
            title="Highest Overlap"
            value="Music Streaming"
            subtitle="3 similar services"
          />

          <AnalyticsMetricCard
            icon={Eye}
            title="Watchlist Items"
            value="5"
            subtitle="Products you're tracking"
          />
        </div>

        <ValuationInputCard
          onCompute={(description, amount) =>
            console.log('Compute valuation:', description, amount)
          }
        />

        <MetricDrilldownCard
          title="Computed Outputs"
          subtitle="AI analysis results"
          items={computedOutputs}
        />

        <MetricDrilldownCard
          title="Raw Inferred Values"
          subtitle="Data points used in analysis"
          items={rawValues}
        />

        <InsightsListSection insights={insights} />
      </div>
    </AppScreen>
  );
};
