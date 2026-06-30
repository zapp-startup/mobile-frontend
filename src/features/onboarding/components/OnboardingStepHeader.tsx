import React from 'react';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';

interface OnboardingStepHeaderProps {
  currentStep: number;
  totalSteps: number;
  title: string;
  subtitle?: string;
}

export const OnboardingStepHeader: React.FC<OnboardingStepHeaderProps> = ({
  currentStep,
  totalSteps,
  title,
  subtitle,
}) => {
  const progress = (currentStep / totalSteps) * 100;

  return (
    <div className="mb-6">
      {/* Progress bar */}
      <div
        className="h-1 rounded-full mb-4"
        style={{ backgroundColor: colors.mutedBorder }}
      >
        <div
          className="h-full rounded-full transition-all duration-300"
          style={{
            width: `${progress}%`,
            backgroundColor: colors.accent,
            boxShadow: `0 0 10px ${colors.accentGlow}`,
          }}
        />
      </div>

      {/* Step indicator */}
      <p
        className="mb-2"
        style={{
          fontSize: typography.small.fontSize,
          color: colors.secondaryText,
        }}
      >
        Step {currentStep} of {totalSteps}
      </p>

      {/* Title */}
      <h2
        style={{
          fontSize: typography.sectionTitle.fontSize,
          fontWeight: typography.sectionTitle.fontWeight,
          color: colors.primaryText,
        }}
      >
        {title}
      </h2>

      {/* Subtitle */}
      {subtitle && (
        <p
          className="mt-2"
          style={{
            fontSize: typography.body.fontSize,
            color: colors.secondaryText,
          }}
        >
          {subtitle}
        </p>
      )}
    </div>
  );
};
