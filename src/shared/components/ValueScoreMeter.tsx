import React from 'react';
import { colors } from '../theme/colors';
import { spacing } from '../theme/spacing';
import { radii } from '../theme/radii';
import { typography } from '../theme/typography';

interface ValueScoreMeterProps {
  score: number; // 0-100
  size?: 'sm' | 'md' | 'lg';
  showLabel?: boolean;
  className?: string;
}

export const ValueScoreMeter: React.FC<ValueScoreMeterProps> = ({
  score,
  size = 'md',
  showLabel = true,
  className = '',
}) => {
  const getColor = (score: number) => {
    if (score >= 70) return colors.valuePositive;
    if (score >= 40) return colors.valueNeutral;
    return colors.valueNegative;
  };

  const sizeConfig = {
    sm: { width: 60, height: 60, strokeWidth: 4, fontSize: '0.875rem' },
    md: { width: 80, height: 80, strokeWidth: 6, fontSize: '1.125rem' },
    lg: { width: 100, height: 100, strokeWidth: 8, fontSize: '1.5rem' },
  }[size];

  const { width, height, strokeWidth, fontSize } = sizeConfig;
  const radius = (width - strokeWidth) / 2;
  const circumference = 2 * Math.PI * radius;
  const offset = circumference - (score / 100) * circumference;

  const scoreColor = getColor(score);

  return (
    <div className={`flex flex-col items-center gap-2 ${className}`}>
      <svg width={width} height={height} className="transform -rotate-90">
        {/* Background circle */}
        <circle
          cx={width / 2}
          cy={height / 2}
          r={radius}
          fill="none"
          stroke={colors.mutedBorder}
          strokeWidth={strokeWidth}
        />
        
        {/* Progress circle */}
        <circle
          cx={width / 2}
          cy={height / 2}
          r={radius}
          fill="none"
          stroke={scoreColor}
          strokeWidth={strokeWidth}
          strokeDasharray={circumference}
          strokeDashoffset={offset}
          strokeLinecap="round"
          className="transition-all duration-500"
        />
        
        {/* Score text */}
        <text
          x={width / 2}
          y={height / 2}
          textAnchor="middle"
          dominantBaseline="middle"
          className="transform rotate-90"
          style={{
            fontSize,
            fontWeight: '700',
            fill: colors.primaryText,
          }}
        >
          {Math.round(score)}
        </text>
      </svg>
      
      {showLabel && (
        <span
          style={{
            fontSize: typography.small.fontSize,
            color: colors.secondaryText,
          }}
        >
          Value Score
        </span>
      )}
    </div>
  );
};
