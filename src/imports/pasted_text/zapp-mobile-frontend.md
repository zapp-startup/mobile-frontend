Build a complete MOBILE-FIRST React frontend for an iPhone version of an existing fintech app called Zapp.

IMPORTANT:
This is NOT a concept app.
This is NOT a simplified MVP.
This is NOT a placeholder demo.

This is a full mobile frontend transformation of an existing production React app.
You must preserve ALL features, ALL screens, ALL data-driven surfaces, ALL backend-connected workflows, and ALL state handling surfaces.

Your job is ONLY to redesign the frontend UX/UI for mobile.
You must NOT simplify functionality.
You must NOT remove screens.
You must NOT replace real product areas with placeholders.
You must NOT invent fake features.
You must NOT ignore edge cases.

This mobile app must be structured so that once connected to the existing backend, dynamic backend data can appear immediately across the app.

-----------------------------------
PRODUCT CONTEXT
-----------------------------------

Zapp is an AI-powered personal finance app with these major domains:
- auth and signup
- MFA setup and verification
- onboarding
- home dashboard
- transactions
- banking / Plaid-linked transactions
- subscriptions
- Spotify subscription enrichment
- circles / social gamification
- badges
- targets
- weekly reviews
- monthly reviews
- analytics / valuation insights
- AI assistant chat
- profile and preferences
- search
- privacy/legal
- callback / processing screens

The current product is a desktop React app with dense card layouts, a fixed top nav, floating AI assistant, floating buy-advisor entry, large charts, and multi-column surfaces. The mobile version must preserve all functionality while reorganizing the UX for iPhone.

-----------------------------------
GLOBAL ARCHITECTURE REQUIREMENTS
-----------------------------------

Use this exact mobile information architecture:

Primary tab bar with 5 tabs:
1. Home
2. Transactions
3. Subscriptions
4. Circles
5. Profile

Use stack navigation inside each tab.
Use sheets / full-screen modals where appropriate.
Do not use desktop top-nav patterns.

Secondary/non-tab flows must still exist:
- Login
- Sign up
- Auth callback
- MFA setup
- MFA verify
- Onboarding
- Search
- Analytics
- Badges
- Targets
- Weekly Review
- Monthly Review
- Privacy Policy
- Spotify callback processing
- AI Assistant
- Buy Advisor modal

These may be reachable through drill-down, header actions, profile links, or internal navigation, but they MUST exist as real screens/surfaces.

-----------------------------------
ABSOLUTE BACKEND COMPATIBILITY RULES
-----------------------------------

Preserve the frontend so it can wire to the existing backend without changing API contracts.

You must design all data-driven UI to support:
- cookie-auth session-based behavior
- CSRF-aware mutations
- auth next-step routing logic
- MFA setup and verify flows
- consent-gated bank connect flow
- bank linking and sync state UI
- transaction CRUD and feedback
- subscription CRUD and valuations
- Spotify connect/sync/disconnect/status
- circles/join/create/member/invite flows
- targets, badges, reviews
- assistant conversation and quick actions
- privacy metadata display

Do NOT redesign away:
- auth branching
- MFA branching
- consent surfaces
- callback screens
- sync states
- loading/empty/error/success states
- quick actions in assistant
- valuation/value score explanation UI
- invite code / group member actions
- review/reflection dialogs

-----------------------------------
VISUAL STYLE
-----------------------------------

Use a premium mobile fintech aesthetic:
- dark theme by default
- neon/high-contrast accent energy
- clean rounded cards
- soft glow highlights
- strong hierarchy
- modern, investor-ready polish
- high readability on phone

Style principles:
- reduce visual clutter from desktop
- preserve the “Zapp” identity
- fewer simultaneous panels
- more progressive disclosure
- stacked sections, drill-down details, clean spacing
- touch-friendly buttons and inputs
- large tap targets
- smooth native-like composition

Recommended design system:
- large radii
- soft shadows or glows
- clear section headers
- strong value score styling
- bright accent for primary actions
- muted surfaces for secondary info
- compact but readable list rows
- charts only where meaningful, otherwise summarize and allow drill-down

-----------------------------------
APP-WIDE DESIGN TOKENS
-----------------------------------

Create and consistently use:
- app background
- elevated surface
- subtle surface
- primary text
- secondary text
- accent
- success
- warning
- error
- muted border
- card glow
- value score positive / neutral / negative tones

Typography system:
- large display title
- screen title
- section title
- card title
- body
- small helper text
- caption
- numeric/stat emphasis style

Spacing system:
- xs / sm / md / lg / xl / 2xl spacing
- card internal padding
- screen section spacing
- list row spacing
- tab bar safe-area spacing
- sheet padding system

-----------------------------------
REQUIRED FILE / FOLDER STRUCTURE
-----------------------------------

Build the project in a feature-structured way. Match this organization style:

src/
  app/
    App.tsx
    routes.tsx
    providers/
      ThemeProvider.tsx
      AppStateProvider.tsx

  navigation/
    RootNavigator.tsx
    AuthNavigator.tsx
    MainTabNavigator.tsx

  features/
    auth/
      screens/
        LoginScreen.tsx
        SignUpScreen.tsx
        AuthCallbackScreen.tsx
        MfaSetupScreen.tsx
        MfaVerifyScreen.tsx
      components/
        AuthCard.tsx
        MfaCodeField.tsx
        SocialAuthButton.tsx

    onboarding/
      screens/
        OnboardingScreen.tsx
      components/
        OnboardingStepHeader.tsx
        OptionButtonGrid.tsx
        SliderQuestion.tsx
        StepFooter.tsx

    home/
      screens/
        HomeScreen.tsx
        AnalyticsSummaryScreen.tsx
      components/
        DashboardHeroCard.tsx
        KpiCard.tsx
        CategoryBreakdownCard.tsx
        RecentTransactionCard.tsx
        GamificationStrip.tsx
        InsightCard.tsx

    transactions/
      screens/
        TransactionsScreen.tsx
        TransactionDetailScreen.tsx
        TransactionFormScreen.tsx
        BankingConnectionsScreen.tsx
        BankConnectionDetailScreen.tsx
        BankTransactionsScreen.tsx
      components/
        TransactionSearchBar.tsx
        TransactionMetricRow.tsx
        TransactionFilterSheet.tsx
        TransactionRow.tsx
        TransactionGroupSection.tsx
        TransactionFeedbackSheet.tsx
        ValueScoreBreakdownCard.tsx
        SpendingCalendarCard.tsx

    banking/
      components/
        BankConnectionCard.tsx
        LinkedAccountRow.tsx
        BankTransactionRow.tsx
        BankConsentModal.tsx
        BankMfaModal.tsx
        SyncStatusBanner.tsx
        BankingEmptyState.tsx

    subscriptions/
      screens/
        SubscriptionsScreen.tsx
        SubscriptionDetailScreen.tsx
        SubscriptionFormScreen.tsx
        SpotifyCallbackScreen.tsx
      components/
        SubscriptionCard.tsx
        SubscriptionValueCard.tsx
        SubscriptionValuationSection.tsx
        SpotifyIntegrationCard.tsx
        SpotifyInsightsCard.tsx

    circles/
      screens/
        CirclesScreen.tsx
        CircleDetailScreen.tsx
        BadgesScreen.tsx
        TargetsScreen.tsx
        WeeklyReviewScreen.tsx
        MonthlyReviewScreen.tsx
      components/
        CircleCard.tsx
        MemberRow.tsx
        LeaderboardRow.tsx
        InviteCodeCard.tsx
        BadgeGrid.tsx
        TargetCard.tsx
        CreateCircleModal.tsx
        JoinCircleModal.tsx
        ReflectionDialog.tsx

    analytics/
      screens/
        AnalyticsScreen.tsx
      components/
        AnalyticsMetricCard.tsx
        ValuationInputCard.tsx
        InsightsListSection.tsx
        MetricDrilldownCard.tsx

    assistant/
      screens/
        AssistantScreen.tsx
      components/
        AssistantHeader.tsx
        MessageBubble.tsx
        QuickActionChip.tsx
        ComposerBar.tsx
        TypingIndicator.tsx

    profile/
      screens/
        ProfileScreen.tsx
        SearchScreen.tsx
        PrivacyPolicyScreen.tsx
      components/
        ProfileIdentityCard.tsx
        FinancialProfileCard.tsx
        PreferencesList.tsx
        AddPreferenceSheet.tsx
        MfaEnrollmentCard.tsx
        SettingsRow.tsx

    buyadvisor/
      components/
        BuyAdvisorModal.tsx
        BuyAdvisorInputStep.tsx
        BuyAdvisorLoadingStep.tsx
        BuyAdvisorResultStep.tsx

  shared/
    components/
      AppHeader.tsx
      AppScreen.tsx
      AppCard.tsx
      AppButton.tsx
      AppInput.tsx
      AppSelect.tsx
      AppTextarea.tsx
      AppSheet.tsx
      AppModal.tsx
      AppEmptyState.tsx
      AppLoadingState.tsx
      AppErrorState.tsx
      StatusChip.tsx
      ValueScoreMeter.tsx
      SectionHeader.tsx
      TabIcon.tsx
    theme/
      colors.ts
      spacing.ts
      typography.ts
      radii.ts
      shadows.ts
    utils/
      formatters.ts
      mockShapes.ts

Do not collapse everything into one file.
Do not use a messy flat structure.
Keep it modular and implementation-ready.

-----------------------------------
GLOBAL APP SHELL
-----------------------------------

Create these global behaviors:

1. Launch / bootstrap state
- full-screen loading / auth check surface
- branded loading appearance
- handles auth readiness before showing app

2. Bottom tab bar
Tabs:
- Home
- Transactions
- Subscriptions
- Circles
- Profile

Use persistent bottom navigation with active-state glow/highlight.

3. Global header behavior
Each main screen should have:
- screen title
- optional right-side action buttons
- optional left-side back button on pushed screens
- safe area aware spacing

4. Global floating utilities from desktop must be redesigned:
- ZappBot floating assistant becomes a full Assistant screen or modal entry
- Buy Advisor floating camera button becomes a discoverable action from relevant screens, preferably Transactions or Home header action

5. Global state surfaces
Every major screen must support:
- loading
- empty
- error
- success
- gated/security/consent
- processing/callback where relevant

-----------------------------------
SCREEN-BY-SCREEN REQUIREMENTS
-----------------------------------

AUTH FLOW

1. LoginScreen
Purpose: sign-in
Sections top to bottom:
- Zapp logo / brand lockup
- title: Welcome back
- subtitle: Enter your credentials to continue
- Continue with Google button
- divider
- Email field
- Password field
- primary Sign in button
- footer text link to Sign up
- privacy / legal line

States:
- idle
- submitting
- auth error
- Google auth error
- success redirect

2. SignUpScreen
Sections:
- brand header
- title: Create your account
- subtitle
- Full name field
- Email field
- Password field
- Confirm password field
- primary Sign up button
- footer link to Sign in
- privacy / legal line

States:
- idle
- validation error
- password mismatch
- loading
- success
- email verification message if applicable

3. AuthCallbackScreen
Purpose: processing only
UI:
- centered loader
- “Signing you in…” or equivalent processing message
- minimal clean callback screen

4. MfaSetupScreen
Sections:
- title + subtitle
- authenticator setup instructions
- QR / setup info surface
- numeric verification code input
- confirm and continue button
- alternate sign out / switch account action
- post-MFA destination info

States:
- setup loading
- code verify failure
- success redirect

5. MfaVerifyScreen
Sections:
- title + subtitle
- authenticator factor selector
- verification code field
- verify and continue CTA
- route continuation info

States:
- no factor selected
- invalid code
- loading
- success

-----------------------------------
ONBOARDING FLOW

6. OnboardingScreen
Use a mobile stepper flow.
Each step must be a dedicated section in a swipeable or stacked/paged flow.

Required questions and data fields:
- life stage
- household size
- zip code
- income range
- monthly fixed expenses
- financial goal
- risk tolerance
- budget style
- priorities: cost / quality / sustainability
- research habit

Each step must include:
- step title
- optional helper text
- relevant input control (button grid, text input, number input, slider)
- back button
- continue button
- complete button on final step
- optional skip if relevant

States:
- step progress indicator
- field validation
- submit loading
- submit error
- submit success

-----------------------------------
HOME TAB

7. HomeScreen
This is the mobile dashboard.

Top to bottom:
- top header with title “Home”
- small right-side actions: Search, Assistant, optional analytics shortcut
- GamificationStrip card near top
- Financial Health hero card
  Includes:
  - large primary amount/stat
  - supporting trend text
  - circular or compact score visualization
- KPI card row or stacked KPI cards
  Examples:
  - streak
  - alerts / health summary
  - savings / spend summary
- Category Breakdown card
  - chart or visual distribution
  - tap through to analytics or transactions
- Recent Transactions card
  - 3–5 rows preview
  - “See all” action
- Insights / Recommendations card
  - AI/value-oriented suggestion card
- Optional buy advisor teaser action

All home content must be vertically stacked for mobile, not multi-column.

States:
- loading dashboard
- empty recent transactions
- partial data
- error state

8. AnalyticsSummaryScreen
This is a lightweight summary/drill-down entry from Home.
Include:
- top KPI summary
- cards for:
  - tracked stacks
  - highest overlap
  - watchlist
- CTA to full analytics screen

-----------------------------------
TRANSACTIONS TAB

9. TransactionsScreen
Top to bottom:
- header title: Transactions
- right-side add button
- search bar: Search transactions...
- compact metric summary row:
  - total transactions
  - total spent
  - total income
  - net
- filter entry row/button opening TransactionFilterSheet
- Spending calendar / heatmap card
- grouped transaction feed by date
- optional section entry to BankingConnectionsScreen

Each transaction row must show:
- description / merchant
- category
- amount
- direction / type
- date
- optional value score or satisfaction indicator if present
- tap to detail
- overflow or swipe actions for edit / delete / feedback

States:
- loading transactions
- empty state: add your first transaction
- filtered empty
- mutation success
- mutation error

10. TransactionDetailScreen
Sections:
- header with transaction title
- amount
- category
- type
- date
- satisfaction / feedback summary if available
- Value Score breakdown card
- actions:
  - edit
  - delete
  - give feedback
  - recompute / refresh if applicable

11. TransactionFormScreen
Use for add and edit.
Fields in order:
- Description
- Amount
- Type
- Category
- Date
- optional Satisfaction
- save/add button
- cancel/back action
If edit mode:
- delete action

States:
- validation errors
- saving
- success
- error

12. TransactionFeedbackSheet
Fields:
- worth-it choice
- regret input/slider
- repurchase likelihood
- usage frequency
- reflection textarea
Actions:
- submit feedback
- save reflection
- cancel

States:
- validation
- submit loading
- success
- error

13. TransactionFilterSheet
Controls:
- category
- type
- date from
- date to
- clear filters
- apply filters
Must feel mobile-native as a bottom sheet.

14. BankingConnectionsScreen
This is a dedicated mobile banking entry instead of burying everything inside desktop transactions.

Top to bottom:
- title: Bank Connections
- security / compliance banner
- if no connections:
  - empty state card
  - connect bank CTA
- if connections exist:
  - list of BankConnectionCard items
  - connect another bank button
- linked accounts section preview
- recent linked bank transactions preview
- sync statuses

Critical states:
- can link
- cannot link due to MFA/security
- consent required
- connecting
- exchanging
- link error
- sync in progress

15. BankConnectionDetailScreen
Show:
- institution/name
- connection status
- last synced
- linked accounts
- recent bank transactions
- sync now button
- disconnect/remove action if appropriate

16. BankTransactionsScreen
List screen for linked bank transactions.
Rows show:
- merchant/description
- amount
- category
- date
- direction
- optional value score indicator

-----------------------------------
BANKING MODALS

17. BankConsentModal
Must be a full mobile sheet or modal.
Show:
- title
- compliance / financial data consent copy
- continue button
- cancel button

18. BankMfaModal
Show:
- title
- explanation
- 6-digit code field
- verify button
- cancel button

-----------------------------------
SUBSCRIPTIONS TAB

19. SubscriptionsScreen
Top to bottom:
- header title: Subscriptions
- add subscription action
- subscriptions list
Each SubscriptionCard shows:
- merchant name
- amount
- billing cycle
- status
- started date
- optional notes preview
- value score / valuation summary
- tap to detail
- edit/delete affordance
- embedded or nearby SpotifyIntegrationCard

Also include:
- valuation explanation / confidence blocks where data exists
- SpotifyIntegrationCard section
- SpotifyInsightsCard where connected

States:
- loading subscriptions
- no subscriptions
- API error
- valuation absent/present
- Spotify disconnected / connected / syncing / failed

20. SubscriptionDetailScreen
Sections:
- merchant title
- amount and cycle
- started date
- notes
- subscription status
- value score display
- valuation breakdown / explanation
- confidence / metadata if present
- actions:
  - edit
  - delete
  - recompute if relevant

21. SubscriptionFormScreen
Fields in order:
- Merchant
- Amount
- Billing cycle
- Start date
- Notes
Actions:
- add/save
- cancel/back

States:
- validation
- saving
- success
- error

22. SpotifyIntegrationCard
Must support:
- connect
- sync
- disconnect
- show status
- show account/product info if connected
- show syncing state
- show message / health / state copy

23. SpotifyInsightsCard
Show connected Spotify-specific insight metrics if available.
Keep this dynamic-data ready, not placeholder.

24. SpotifyCallbackScreen
Processing screen with:
- spinner
- finishing Spotify text
- success/failure messaging
- auto-return behavior

-----------------------------------
CIRCLES TAB

25. CirclesScreen
Top to bottom:
- title: Circles
- right-side actions:
  - create circle
  - join circle
- list of CircleCard items

Each CircleCard shows:
- circle name
- member count
- privacy status
- invite or participation status
- tap to detail

If no circles:
- clean empty state with create and join actions

26. CircleDetailScreen
Sections:
- circle title
- privacy/member status chips
- InviteCodeCard
- stats cards:
  - current window
  - your rank
  - leaderboard entries
- members section
- leaderboard section
- actions:
  - leave circle
  - member actions if allowed
  - invite/share code

This screen replaces desktop split-pane with stacked drill-down sections.

27. BadgesScreen
Sections:
- title
- summary stat cards:
  - total badges
  - latest unlock
- BadgeGrid

States:
- loading
- no badges

28. TargetsScreen
Sections:
- title
- list of target cards
- create target CTA
- inline or sheet-based target creation flow

Each target shows:
- title
- type
- target value
- progress / status

29. WeeklyReviewScreen
Sections:
- title
- overview metrics
  - reviewed purchases
  - pending
- review prompt blocks with textarea fields
- transaction review entry cards
- final submission section

30. MonthlyReviewScreen
Same structure as weekly but monthly framing.

31. ReflectionDialog
For transaction reflection inside reviews.
Fields:
- regret score
- worth-it choice
- notes textarea
Actions:
- save reflection
- cancel

32. CreateCircleModal
Fields:
- circle name
- private toggle
Actions:
- create
- cancel

33. JoinCircleModal
Fields:
- invite code
Actions:
- join
- cancel

-----------------------------------
ANALYTICS

34. AnalyticsScreen
This must be a drill-down screen reachable from Home or Profile/More.

Top to bottom:
- title
- analytics metric cards:
  - tracked stacks
  - highest overlap
  - watchlist
- valuation input card:
  - description
  - amount
- sections for:
  - computed outputs
  - raw inferred values
  - value outputs
Use cards and expandable sections.
Avoid desktop-style dense multi-column layouts.

-----------------------------------
ASSISTANT

35. AssistantScreen
This replaces the desktop floating side panel.

Top to bottom:
- Assistant header with title and close/back action
- Start new chat action
- message list
- optional quick action chips under assistant messages
- typing indicator
- composer bar:
  - text input placeholder: Ask ZappBot anything...
  - send button

MessageBubble states:
- user bubble
- assistant bubble
- assistant quick actions
- typing
- conversation recovery/fallback if conversation not found

Must support:
- open assistant from Home/Profile/global action
- send message
- new chat
- quick action tap
- empty initial conversation state

-----------------------------------
PROFILE TAB

36. ProfileScreen
Top to bottom:
- profile header
- ProfileIdentityCard
  - name
  - email
  - tier
- FinancialProfileCard
  - editable financial profile fields
- PreferencesList
  - current preferences
  - add/remove preference actions
- MfaEnrollmentCard
- settings/action rows:
  - analytics
  - search
  - privacy
  - logout

States:
- loading profile
- loading preferences
- save success/error
- add/remove preference success/error

37. SearchScreen
Simple but polished.
Sections:
- title: Search
- large search input
- helper/supporting text
- cards or callouts for search exploration
Keep this real, not placeholder-looking.

38. PrivacyPolicyScreen
Legal content screen.
Sections:
- title
- policy metadata
  - version
  - effective date
- sectioned content blocks with separators
- readable legal typography
- back navigation

-----------------------------------
BUY ADVISOR

39. BuyAdvisorModal
This must exist as a full-screen modal or sheet.
3-step structure:
- input step
- loading step
- result step

Input fields:
- predicted price
- target category

Actions:
- analyze
- close
- back when relevant

-----------------------------------
COMPONENT LIBRARY REQUIREMENTS
-----------------------------------

Create reusable mobile components for:

Core:
- AppScreen
- AppHeader
- AppCard
- SectionHeader
- AppButton
- AppInput
- AppSelect
- AppTextarea
- AppSheet
- AppModal
- AppEmptyState
- AppLoadingState
- AppErrorState

Financial:
- ValueScoreMeter
- KpiCard
- DashboardHeroCard
- TransactionRow
- SubscriptionCard
- SubscriptionValueCard
- BankConnectionCard
- LinkedAccountRow
- BankTransactionRow

Gamification:
- CircleCard
- MemberRow
- LeaderboardRow
- BadgeCard / badge tile
- TargetCard
- InviteCodeCard

Assistant:
- MessageBubble
- QuickActionChip
- ComposerBar
- TypingIndicator

States:
- inline success state
- inline warning state
- sync state banner
- gated security state card

-----------------------------------
DATA-READY UI RULES
-----------------------------------

Design every screen so it is clearly ready for dynamic backend data.

These data areas MUST be supported explicitly:

Auth / User
- user name
- initials/avatar
- email
- tier
- next-step state
- MFA state / factor list

Transactions
- description
- amount
- type
- category
- date
- satisfaction
- regret
- repurchase
- usage frequency
- reflection
- value score

Banking
- bank connection institution/name/status/last synced
- bank account name/type/mask/balance
- bank transaction merchant/amount/category/date/type/value score
- consent and security gate states
- sync progress

Subscriptions
- merchant
- amount
- billing cycle
- started date
- notes
- status
- value score
- valuation explanation
- confidence

Spotify
- connected/disconnected/syncing/error
- account/display info
- health/status message
- insight metrics

Circles
- circle name
- member count
- privacy
- invite code
- rank
- leaderboard entries
- member actions

Targets / Badges / Reviews
- target title/type/value/progress
- badge total/latest unlock/badge tiles
- review prompt answers
- reviewed / pending metrics
- reflection data

Analytics
- tracked stacks
- highest overlap
- watchlist
- valuation input and output sections
- computed and inferred values

Assistant
- conversation list state
- message role/content/timestamps
- quick actions
- send state
- typing state
- recovery state

Privacy
- version
- effective date
- policy metadata

Do not make these generic.
The UI must clearly expose where this backend data will render.

-----------------------------------
INTERACTION RULES
-----------------------------------

Preserve these interactions:
- auth submit
- Google sign in
- MFA enroll/verify
- onboarding next/back/complete
- add/edit/delete transaction
- open feedback sheet
- filter transactions
- connect bank
- confirm consent
- verify MFA for bank link
- sync connection
- add/edit/delete subscription
- Spotify connect/sync/disconnect
- create/join circle
- leave circle
- member actions
- create target
- submit weekly/monthly review
- open reflection dialog
- send assistant message
- quick action tap
- save profile
- add/remove preference
- open privacy
- logout
- run Buy Advisor flow

-----------------------------------
STATE DESIGN RULES
-----------------------------------

Every major surface must include designed states for:
- loading
- empty
- error
- success
- processing
- disabled
- gated/security-blocked
- consent-required
- sync-in-progress
- callback-processing

Do not leave these undefined.
Design them as first-class mobile states.

-----------------------------------
MOBILE UX TRANSFORMATION RULES
-----------------------------------

Apply these conversions:
- desktop floating assistant -> Assistant screen/modal
- desktop floating buy-advisor -> explicit modal entry
- multi-column dashboard -> single-column stacked cards
- desktop split panes -> push navigation
- dense filters -> bottom sheet
- large chart panels -> compact summary + drill-down
- embedded banking desktop block -> dedicated mobile banking screens under Transactions
- desktop circles split layout -> circles list -> circle detail stack
- large desktop forms -> full-screen mobile form screens or sheets

-----------------------------------
QUALITY BAR
-----------------------------------

The output must feel like:
- a polished App Store fintech app
- premium, modern, clean
- realistic for implementation
- built for dynamic data
- not a mock toy
- not a simplified clone
- not placeholder-heavy

-----------------------------------
FINAL INSTRUCTION
-----------------------------------

Build the COMPLETE mobile frontend system with all the screens, components, states, and navigation described above.

Do not ignore any feature.
Do not omit any modal.
Do not replace anything with placeholders.
Do not simplify data surfaces.
Do not skip state handling.
Do not create a generic finance app.
Create the actual mobile frontend architecture and UI for Zapp.