# Zapp iOS Frontend — Fix-Up Plan

Target: **SwiftUI iOS app** (`ZappApp/`). Goals: build & run, finish backend wiring, fix bugs/UX, meaningful design restyle.
Testing after every step. Testable with **or without** a live backend (`ZAPP_API_BASE_URL`; offline via `URLProtocol` stub).

## Phase 0 — Reproducible build baseline ✅ DONE
- [x] Fix `xcodegen`: `info.path` was missing in `project.yml` (spec-parse failure); restored `path: ZappApp/Info.plist`.
- [x] Add missing `ZappApp/Resources/Assets.xcassets` (Contents.json, AppIcon.appiconset).
- [x] Clear warnings: unused `if let connectionId` binding; unreachable `catch` in `connectBank()`.
- [x] Add `ZappAppTests` unit-test target + `URLProtocolStub` offline harness + smoke tests (2 pass).
- **Verified:** `xcodegen generate` ✓, `xcodebuild build` ✓, `xcodebuild test` ✓ (2/2).

## Phase 1 — Finish backend wiring ✅ DONE
- [x] Remove dead `AppState.loginMockUser()`.
- [x] `BuyAdvisorService` now defaults to the real endpoint (`useMockData:false`, `/api/buy-advisor/analyze`); mock branch kept for tests only.
- [x] `TransactionFormViewModel` `MockSeed.isoNow` → `ISO8601DateFormatter().string(from: Date())`.
- Only remaining `MockSeed` use is the intentional opt-in test branch. No fabricated data left (Home KPI deltas, subscription valuation, etc. all removed).

## Phase 2 — Per-feature bug/UX audit + fixes ✅ DONE
Parallel read-only audits (8 agents) → ~45 concrete findings → parallel apply-agents (feature-scoped, shared files handled centrally) → single integration build.
**Result:** `xcodegen ✓ · build ✓ (no warnings) · test 2/2 ✓`.
Highlights fixed: fake KPI deltas, dead "See all"/"View Detail" buttons, empty-credential & numeric-keyboard gaps (shared `AppInput`), signup name dropped, transient-logout on onboarding check, MFA min-length, transaction date-filter dead, stale-list-after-save (Transactions+Subscriptions), Spotify false-success, Assistant swallowed errors + autoscroll, Circles empty-name/invite validation + copy invite + real Create-Target modal + retry on error states.
**Deferred (need backend contract or larger feature work):** Spotify OAuth code-exchange, full MFA QR/verify flow, real Profile search endpoint, review-summary prompt-id keying, some N+1 service refetches.

## Phase 3 — Design restyle: "refined dark" ✅ (token-level) / per-screen pass pending backend
Direction: evolve the neon-on-navy look into something intentional. Done centrally in 2 token files (no call-site edits):
- [x] `Typography.swift` → native SF Pro with a real weight ladder (bold→semibold→regular) + `.rounded` design and **monospaced digits** on money/metrics. Fixes the never-bundled `Font.custom("Inter")` silent fallback.
- [x] `Colors.swift` → warm near-black `#0A0E16`, softer off-white text, **one** teal brand accent (`#38E0C8`), neon glows dialed down (~0.10–0.16), decorative rainbow demoted to status-only.
- [x] `Color(hex:)` now supports #RGB / #RRGGBB / #RRGGBBAA and falls back to clear (was returning **white** on any non-6-digit input).
- **Verified:** build ✓, launched in simulator, login screen screenshotted — cohesive refined-dark look.
- [ ] Per-screen visual fine-tune of data screens (Home/Analytics/Circles) — needs a live backend to render with real data.

## Commands
```
xcodegen generate
xcodebuild -project ZappApp.xcodeproj -scheme ZappApp -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 17' build
xcodebuild -project ZappApp.xcodeproj -scheme ZappApp -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 17' test
ZAPP_API_BASE_URL=http://localhost:8000   # point at a real backend when available
```
