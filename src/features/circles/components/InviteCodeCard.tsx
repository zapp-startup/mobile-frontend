import React from 'react';
import { Copy, CheckCircle } from 'lucide-react';
import { AppCard } from '../../../shared/components/AppCard';
import { AppButton } from '../../../shared/components/AppButton';
import { SectionHeader } from '../../../shared/components/SectionHeader';
import { colors } from '../../../shared/theme/colors';
import { typography } from '../../../shared/theme/typography';
import { radii } from '../../../shared/theme/radii';

interface InviteCodeCardProps {
  code: string;
}

export const InviteCodeCard: React.FC<InviteCodeCardProps> = ({ code }) => {
  const [copied, setCopied] = React.useState(false);

  const handleCopy = () => {
    navigator.clipboard.writeText(code);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <AppCard>
      <SectionHeader title="Invite Code" subtitle="Share this code to invite others" />

      <div
        className="p-4 rounded-lg text-center my-4"
        style={{
          backgroundColor: colors.subtleSurface,
          border: `2px dashed ${colors.accent}`,
        }}
      >
        <p
          className="font-mono tracking-widest"
          style={{
            fontSize: typography.sectionTitle.fontSize,
            fontWeight: '700',
            color: colors.accent,
          }}
        >
          {code}
        </p>
      </div>

      <AppButton
        variant={copied ? 'secondary' : 'outline'}
        fullWidth
        onClick={handleCopy}
      >
        {copied ? (
          <>
            <CheckCircle size={16} className="inline mr-2" />
            Copied!
          </>
        ) : (
          <>
            <Copy size={16} className="inline mr-2" />
            Copy Code
          </>
        )}
      </AppButton>
    </AppCard>
  );
};
