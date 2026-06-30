import React, { useState } from 'react';
import { useNavigate, useParams } from 'react-router';
import { Edit2, Trash2, MessageSquare } from 'lucide-react';
import { AppScreen } from '../../../shared/components/AppScreen';
import { AppHeader } from '../../../shared/components/AppHeader';
import { AppCard } from '../../../shared/components/AppCard';
import { AppButton } from '../../../shared/components/AppButton';
import { SectionHeader } from '../../../shared/components/SectionHeader';
import { ValueScoreBreakdownCard } from '../components/ValueScoreBreakdownCard';
import { TransactionFeedbackSheet } from '../components/TransactionFeedbackSheet';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';
import { formatCurrency, formatDate } from '../../../shared/utils/formatters';

export const TransactionDetailScreen: React.FC = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const [feedbackSheetOpen, setFeedbackSheetOpen] = useState(false);

  // Mock data
  const transaction = {
    id,
    description: 'Whole Foods',
    amount: -67.42,
    type: 'expense',
    category: 'Groceries',
    date: '2026-04-15',
    satisfaction: 8,
    valueScore: 78,
  };

  const scoreFactors = [
    { name: 'Price vs. Value', score: 85, weight: 35 },
    { name: 'Necessity', score: 90, weight: 25 },
    { name: 'Quality', score: 75, weight: 20 },
    { name: 'Sustainability', score: 60, weight: 20 },
  ];

  return (
    <AppScreen>
      <AppHeader title="Transaction Details" showBack />

      <div className="px-4 py-6 space-y-4">
        <AppCard>
          <h2
            style={{
              fontSize: typography.sectionTitle.fontSize,
              fontWeight: typography.sectionTitle.fontWeight,
              color: colors.primaryText,
              marginBottom: '1rem',
            }}
          >
            {transaction.description}
          </h2>

          <div className="space-y-3">
            <div className="flex justify-between py-2 border-b" style={{ borderColor: colors.mutedBorder }}>
              <span style={{ color: colors.secondaryText }}>Amount</span>
              <span
                style={{
                  fontSize: typography.cardTitle.fontSize,
                  fontWeight: '700',
                  color: transaction.type === 'income' ? colors.success : colors.error,
                }}
              >
                {transaction.type === 'income' ? '+' : '-'}{formatCurrency(Math.abs(transaction.amount))}
              </span>
            </div>

            <div className="flex justify-between py-2 border-b" style={{ borderColor: colors.mutedBorder }}>
              <span style={{ color: colors.secondaryText }}>Category</span>
              <span style={{ color: colors.primaryText }}>{transaction.category}</span>
            </div>

            <div className="flex justify-between py-2 border-b" style={{ borderColor: colors.mutedBorder }}>
              <span style={{ color: colors.secondaryText }}>Type</span>
              <span style={{ color: colors.primaryText }}>{transaction.type}</span>
            </div>

            <div className="flex justify-between py-2">
              <span style={{ color: colors.secondaryText }}>Date</span>
              <span style={{ color: colors.primaryText }}>{formatDate(transaction.date)}</span>
            </div>
          </div>
        </AppCard>

        <ValueScoreBreakdownCard score={transaction.valueScore} factors={scoreFactors} />

        <div className="grid grid-cols-2 gap-3">
          <AppButton
            variant="secondary"
            onClick={() => navigate(`/transactions/${id}/edit`)}
          >
            <Edit2 size={16} className="inline mr-2" />
            Edit
          </AppButton>
          <AppButton variant="danger">
            <Trash2 size={16} className="inline mr-2" />
            Delete
          </AppButton>
        </div>

        <AppButton
          variant="outline"
          fullWidth
          onClick={() => setFeedbackSheetOpen(true)}
        >
          <MessageSquare size={16} className="inline mr-2" />
          Give Feedback
        </AppButton>
      </div>

      <TransactionFeedbackSheet
        isOpen={feedbackSheetOpen}
        onClose={() => setFeedbackSheetOpen(false)}
        transactionId={id || ''}
        onSubmit={(feedback) => console.log('Feedback:', feedback)}
      />
    </AppScreen>
  );
};
