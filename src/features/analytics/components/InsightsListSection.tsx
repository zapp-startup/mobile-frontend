import React from 'react';
import { Sparkles } from 'lucide-react';
import { SectionHeader } from '../../../shared/components/SectionHeader';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';
import { radii } from '../../../shared/theme/radii';

interface Insight {
  id: string;
  title: string;
  description: string;
}

interface InsightsListSectionProps {
  insights: Insight[];
}

export const InsightsListSection: React.FC<InsightsListSectionProps> = ({ insights }) => {
  return (
    <div>
      <SectionHeader title="AI Insights" subtitle="Personalized recommendations" />
      
      <div className="space-y-3 mt-4">
        {insights.map((insight) => (
          <div
            key={insight.id}
            className="flex gap-3 p-3"
            style={{
              backgroundColor: colors.elevatedSurface,
              borderRadius: radii.lg,
            }}
          >
            <div
              className="p-2 rounded-lg h-fit"
              style={{ backgroundColor: `${colors.accent}20` }}
            >
              <Sparkles size={16} color={colors.accent} />
            </div>

            <div className="flex-1">
              <p
                style={{
                  fontSize: typography.body.fontSize,
                  fontWeight: '500',
                  color: colors.primaryText,
                }}
              >
                {insight.title}
              </p>
              <p
                className="mt-1"
                style={{
                  fontSize: typography.small.fontSize,
                  color: colors.secondaryText,
                }}
              >
                {insight.description}
              </p>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};
