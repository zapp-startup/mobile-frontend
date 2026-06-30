import React from 'react';
import { AppButton } from '../../../shared/components/AppButton';

interface StepFooterProps {
  onBack?: () => void;
  onNext: () => void;
  onSkip?: () => void;
  nextLabel?: string;
  nextDisabled?: boolean;
  isLastStep?: boolean;
}

export const StepFooter: React.FC<StepFooterProps> = ({
  onBack,
  onNext,
  onSkip,
  nextLabel = 'Continue',
  nextDisabled = false,
  isLastStep = false,
}) => {
  return (
    <div className="space-y-3 mt-8">
      <AppButton
        fullWidth
        onClick={onNext}
        disabled={nextDisabled}
      >
        {isLastStep ? 'Complete' : nextLabel}
      </AppButton>

      <div className="flex gap-3">
        {onBack && (
          <AppButton
            fullWidth
            variant="secondary"
            onClick={onBack}
          >
            Back
          </AppButton>
        )}

        {onSkip && (
          <AppButton
            fullWidth
            variant="ghost"
            onClick={onSkip}
          >
            Skip
          </AppButton>
        )}
      </div>
    </div>
  );
};
