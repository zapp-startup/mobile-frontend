import React, { useState } from 'react';
import { X } from 'lucide-react';
import { colors } from '../../../shared/theme/colors';
import { spacing } from '../../../shared/theme/spacing';
import { radii } from '../../../shared/theme/radii';
import { BuyAdvisorInputStep } from './BuyAdvisorInputStep';
import { BuyAdvisorLoadingStep } from './BuyAdvisorLoadingStep';
import { BuyAdvisorResultStep } from './BuyAdvisorResultStep';

interface BuyAdvisorModalProps {
  isOpen: boolean;
  onClose: () => void;
}

export const BuyAdvisorModal: React.FC<BuyAdvisorModalProps> = ({ isOpen, onClose }) => {
  const [step, setStep] = useState<'input' | 'loading' | 'result'>('input');
  const [predictedPrice, setPredictedPrice] = useState('');
  const [category, setCategory] = useState('');

  const handleAnalyze = () => {
    setStep('loading');
    setTimeout(() => {
      setStep('result');
    }, 2500);
  };

  const handleReset = () => {
    setStep('input');
    setPredictedPrice('');
    setCategory('');
  };

  if (!isOpen) return null;

  return (
    <>
      <div
        className="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm"
        onClick={onClose}
      />
      
      <div
        className="fixed inset-0 z-50 flex items-center justify-center p-4"
        onClick={(e) => e.stopPropagation()}
      >
        <div
          className="w-full max-w-md"
          style={{
            backgroundColor: colors.elevatedSurface,
            borderRadius: radii.xl,
            padding: spacing.cardPaddingLg,
            maxHeight: '90vh',
            overflowY: 'auto',
          }}
        >
          <div className="flex items-center justify-between mb-6">
            <h2
              style={{
                fontSize: '1.5rem',
                fontWeight: '600',
                color: colors.primaryText,
              }}
            >
              Buy Advisor
            </h2>
            <button
              onClick={onClose}
              className="p-2 rounded-lg active:opacity-70 transition-opacity"
              style={{ color: colors.secondaryText }}
            >
              <X size={20} />
            </button>
          </div>

          {step === 'input' && (
            <BuyAdvisorInputStep
              predictedPrice={predictedPrice}
              category={category}
              onPriceChange={setPredictedPrice}
              onCategoryChange={setCategory}
              onAnalyze={handleAnalyze}
              onCancel={onClose}
            />
          )}

          {step === 'loading' && <BuyAdvisorLoadingStep />}

          {step === 'result' && (
            <BuyAdvisorResultStep
              valueScore={82}
              recommendation="Good buy"
              insights={[
                'Price is 15% below market average',
                'High value for this category',
                'Aligns with your spending preferences',
              ]}
              onReset={handleReset}
              onClose={onClose}
            />
          )}
        </div>
      </div>
    </>
  );
};
