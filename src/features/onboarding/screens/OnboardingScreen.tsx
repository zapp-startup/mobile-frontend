import React, { useState } from 'react';
import { useNavigate } from 'react-router';
import { AppScreen } from '../../../shared/components/AppScreen';
import { AppCard } from '../../../shared/components/AppCard';
import { AppInput } from '../../../shared/components/AppInput';
import { OnboardingStepHeader } from '../components/OnboardingStepHeader';
import { OptionButtonGrid } from '../components/OptionButtonGrid';
import { SliderQuestion } from '../components/SliderQuestion';
import { StepFooter } from '../components/StepFooter';
import { FinancialProfile } from '../../../shared/utils/mockShapes';

const TOTAL_STEPS = 10;

export const OnboardingScreen: React.FC = () => {
  const navigate = useNavigate();
  const [currentStep, setCurrentStep] = useState(1);
  const [profile, setProfile] = useState<Partial<FinancialProfile>>({
    priorities: { cost: 50, quality: 50, sustainability: 50 },
  });

  const updateProfile = (key: keyof FinancialProfile, value: any) => {
    setProfile((prev) => ({ ...prev, [key]: value }));
  };

  const handleNext = () => {
    if (currentStep < TOTAL_STEPS) {
      setCurrentStep(currentStep + 1);
    } else {
      // Submit onboarding data
      console.log('Onboarding complete', profile);
      navigate('/');
    }
  };

  const handleBack = () => {
    if (currentStep > 1) {
      setCurrentStep(currentStep - 1);
    }
  };

  const renderStep = () => {
    switch (currentStep) {
      case 1:
        return (
          <div>
            <OnboardingStepHeader
              currentStep={currentStep}
              totalSteps={TOTAL_STEPS}
              title="What's your life stage?"
              subtitle="This helps us personalize your experience"
            />
            <OptionButtonGrid
              options={[
                { value: 'student', label: 'Student' },
                { value: 'early-career', label: 'Early Career' },
                { value: 'established', label: 'Established' },
                { value: 'pre-retirement', label: 'Pre-Retirement' },
              ]}
              selected={profile.lifeStage || ''}
              onChange={(value) => updateProfile('lifeStage', value)}
            />
          </div>
        );

      case 2:
        return (
          <div>
            <OnboardingStepHeader
              currentStep={currentStep}
              totalSteps={TOTAL_STEPS}
              title="Household size"
              subtitle="How many people live in your household?"
            />
            <SliderQuestion
              value={profile.householdSize || 1}
              onChange={(value) => updateProfile('householdSize', value)}
              min={1}
              max={8}
              labels={{ min: '1 person', max: '8+ people' }}
            />
          </div>
        );

      case 3:
        return (
          <div>
            <OnboardingStepHeader
              currentStep={currentStep}
              totalSteps={TOTAL_STEPS}
              title="Where are you located?"
              subtitle="We'll use this for local insights"
            />
            <AppInput
              label="Zip Code"
              value={profile.zipCode || ''}
              onChange={(value) => updateProfile('zipCode', value)}
              placeholder="12345"
              type="text"
            />
          </div>
        );

      case 4:
        return (
          <div>
            <OnboardingStepHeader
              currentStep={currentStep}
              totalSteps={TOTAL_STEPS}
              title="Income range"
              subtitle="Your approximate annual income"
            />
            <OptionButtonGrid
              options={[
                { value: '0-30k', label: '$0-30k' },
                { value: '30-60k', label: '$30-60k' },
                { value: '60-100k', label: '$60-100k' },
                { value: '100-150k', label: '$100-150k' },
                { value: '150k+', label: '$150k+' },
                { value: 'prefer-not', label: 'Prefer not to say' },
              ]}
              selected={profile.incomeRange || ''}
              onChange={(value) => updateProfile('incomeRange', value)}
              columns={2}
            />
          </div>
        );

      case 5:
        return (
          <div>
            <OnboardingStepHeader
              currentStep={currentStep}
              totalSteps={TOTAL_STEPS}
              title="Monthly fixed expenses"
              subtitle="Rent, utilities, subscriptions, etc."
            />
            <AppInput
              label="Amount ($)"
              value={profile.monthlyFixedExpenses?.toString() || ''}
              onChange={(value) => updateProfile('monthlyFixedExpenses', Number(value))}
              placeholder="1500"
              type="number"
            />
          </div>
        );

      case 6:
        return (
          <div>
            <OnboardingStepHeader
              currentStep={currentStep}
              totalSteps={TOTAL_STEPS}
              title="Financial goal"
              subtitle="What's your primary financial objective?"
            />
            <OptionButtonGrid
              options={[
                { value: 'save', label: 'Save Money' },
                { value: 'debt', label: 'Pay Off Debt' },
                { value: 'invest', label: 'Start Investing' },
                { value: 'budget', label: 'Better Budgeting' },
                { value: 'retire', label: 'Retirement' },
                { value: 'other', label: 'Other' },
              ]}
              selected={profile.financialGoal || ''}
              onChange={(value) => updateProfile('financialGoal', value)}
              columns={2}
            />
          </div>
        );

      case 7:
        return (
          <div>
            <OnboardingStepHeader
              currentStep={currentStep}
              totalSteps={TOTAL_STEPS}
              title="Risk tolerance"
              subtitle="How comfortable are you with financial risk?"
            />
            <OptionButtonGrid
              options={[
                { value: 'conservative', label: 'Conservative' },
                { value: 'moderate', label: 'Moderate' },
                { value: 'aggressive', label: 'Aggressive' },
              ]}
              selected={profile.riskTolerance || ''}
              onChange={(value) => updateProfile('riskTolerance', value)}
            />
          </div>
        );

      case 8:
        return (
          <div>
            <OnboardingStepHeader
              currentStep={currentStep}
              totalSteps={TOTAL_STEPS}
              title="Budget style"
              subtitle="How do you prefer to manage your money?"
            />
            <OptionButtonGrid
              options={[
                { value: 'detailed', label: 'Detailed Tracking' },
                { value: 'balanced', label: 'Balanced' },
                { value: 'flexible', label: 'Flexible' },
                { value: 'minimal', label: 'Minimal Effort' },
              ]}
              selected={profile.budgetStyle || ''}
              onChange={(value) => updateProfile('budgetStyle', value)}
              columns={2}
            />
          </div>
        );

      case 9:
        return (
          <div>
            <OnboardingStepHeader
              currentStep={currentStep}
              totalSteps={TOTAL_STEPS}
              title="Spending priorities"
              subtitle="Rate what matters most to you"
            />
            <div className="space-y-6">
              <div>
                <label className="block mb-2 text-sm font-medium">Cost</label>
                <SliderQuestion
                  value={profile.priorities?.cost || 50}
                  onChange={(value) =>
                    updateProfile('priorities', { ...profile.priorities, cost: value })
                  }
                  min={0}
                  max={100}
                  labels={{ min: 'Not important', max: 'Very important' }}
                />
              </div>
              <div>
                <label className="block mb-2 text-sm font-medium">Quality</label>
                <SliderQuestion
                  value={profile.priorities?.quality || 50}
                  onChange={(value) =>
                    updateProfile('priorities', { ...profile.priorities, quality: value })
                  }
                  min={0}
                  max={100}
                  labels={{ min: 'Not important', max: 'Very important' }}
                />
              </div>
              <div>
                <label className="block mb-2 text-sm font-medium">Sustainability</label>
                <SliderQuestion
                  value={profile.priorities?.sustainability || 50}
                  onChange={(value) =>
                    updateProfile('priorities', { ...profile.priorities, sustainability: value })
                  }
                  min={0}
                  max={100}
                  labels={{ min: 'Not important', max: 'Very important' }}
                />
              </div>
            </div>
          </div>
        );

      case 10:
        return (
          <div>
            <OnboardingStepHeader
              currentStep={currentStep}
              totalSteps={TOTAL_STEPS}
              title="Research habit"
              subtitle="How do you typically research purchases?"
            />
            <OptionButtonGrid
              options={[
                { value: 'extensive', label: 'Extensive Research' },
                { value: 'moderate', label: 'Some Research' },
                { value: 'minimal', label: 'Quick Checks' },
                { value: 'impulse', label: 'Impulse Buyer' },
              ]}
              selected={profile.researchHabit || ''}
              onChange={(value) => updateProfile('researchHabit', value)}
              columns={2}
            />
          </div>
        );

      default:
        return null;
    }
  };

  return (
    <AppScreen padding={false}>
      <div className="min-h-screen py-8 px-4">
        <AppCard>
          {renderStep()}

          <StepFooter
            onBack={currentStep > 1 ? handleBack : undefined}
            onNext={handleNext}
            nextDisabled={false}
            isLastStep={currentStep === TOTAL_STEPS}
          />
        </AppCard>
      </div>
    </AppScreen>
  );
};
