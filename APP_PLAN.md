# Marx App Launch Plan

## 1. Current App State

- The app already has a bootstrap gate in [lib/main.dart](lib/main.dart#L1) and a router-driven shell in [lib/app.dart](lib/app.dart#L1).
- Core content surfaces already exist: home feed, quote detail, archive, thinkers, quiz, onboarding, settings, and premium/paywall flows.
- Monetization infrastructure is already present through RevenueCat integration, plus premium and paywall screens.
- Widget sync, notifications, streaks, sharing, TTS, and daily content resolution are already part of the product foundation.

## 2. Launch Goal

Ship a stable, polished, monetizable app with a clean free experience and a clear pro upgrade path.

## 3. Implementation Status

- [x] Widget sync on the Home screen deduplicated and protected against sync failures.
- [x] Notification settings now surface scheduling failures instead of failing silently.
- [x] Home screen listeners moved out of build to avoid rebuild-driven duplicate subscriptions.
- [x] Repository seeding now fails open during bootstrap instead of blocking launch.
- [x] Bootstrap hardening and startup fallback cleanup.
- [x] Startup loading and recovery screens polished.
- [x] Premium overview and purchase surface polished.
- [x] Home and archive entry surfaces polished.
- [x] Thinkers entry surface polished.
- [x] Main-page actions tab removed.
- [x] Quiz, favorites, and onboarding entry surfaces polished.
- [x] Settings and quote detail entry surfaces polished.
- [x] Political orientation entry surface polished.
- [x] Admin dashboard entry surface polished.
- [x] Monetization entry and paywall button hardened.
- [ ] UI polish across the main screens.
- [ ] RevenueCat and paywall flow audit.
- [ ] Pro feature expansion after the core is stable.

## 3.1 Immediate Work Queue

1. Finish the remaining UI polish on the screens that still feel most functional: [lib/presentation/quiz](lib/presentation/quiz), [lib/presentation/favorites](lib/presentation/favorites), [lib/presentation/onboarding](lib/presentation/onboarding), and the remaining detail-style surfaces.
2. Audit the monetization path end to end in [lib/core/services/purchases_service.dart](lib/core/services/purchases_service.dart), [lib/presentation/paywall/purchase_page.dart](lib/presentation/paywall/purchase_page.dart), and the routes that decide whether Pro content is visible.
3. Define the first Pro feature bundle in terms of concrete screens and interactions, not abstract ideas.

## 4. Roadmap Until Launch

### Phase 1: Stabilize the App Without Bugs

**Goal:** Make the current experience reliable before adding anything new.

- Fix crashes, broken flows, and inconsistent state handling in bootstrap, navigation, daily content, and settings.
- Verify that content loading, widget sync, streak updates, and refresh flows work consistently across cold start, background refresh, and manual refresh.
- Harden error states so failed fetches, empty content, and SDK failures show a usable fallback instead of breaking the app.
- Clean up code paths that are duplicated or partially migrated before they become launch risks.
- Validate Android and iOS behavior separately for notifications, widgets, purchases, and deep links.

**Exit criteria:** Main user flows work without known high-severity bugs, and the app can be used daily without manual recovery.

### Phase 2: Improve the UI

**Goal:** Make the app feel finished, readable, and intentional.

- Polish the home screen hierarchy so the daily quote, context, streak, and supporting actions read in a clear order.
- Tighten typography, spacing, and card consistency across home, detail, archive, quiz, onboarding, favorites, and settings.
- Improve transitions and loading states so the app feels responsive instead of abrupt.
- Refine premium and paywall screens so the value proposition is understandable in seconds.
- Ensure dark/light presentation, accessibility contrast, and responsive layouts are solid before launch.

**Exit criteria:** The app looks cohesive across the main screens and the premium surface feels like part of the same product.

**Done when:** The remaining primary screens share the same visual language, no screen feels like a placeholder, and the navigation surfaces no longer look disconnected from the editorial styling.

### Phase 3: Improve Monetization

**Goal:** Make monetization trustworthy, understandable, and testable.

- Audit RevenueCat setup, entitlement handling, restore flows, customer center access, and purchase failures.
- Verify that [lib/presentation/paywall/purchase_page.dart](lib/presentation/paywall/purchase_page.dart) has a clear free-vs-pro message, obvious restore entry, and graceful error states.
- Verify that [lib/core/services/purchases_service.dart](lib/core/services/purchases_service.dart) correctly maps offerings, purchases, restores, and entitlement refresh.
- Align premium messaging with actual paid value so the paywall explains why Pro exists.
- Decide what remains free, what becomes pro, and what should be previewable before purchase.
- Reduce friction in purchase, restore, and entitlement refresh flows.
- Prepare analytics or internal tracking for conversion points if the app is already collecting events.

**Exit criteria:** The subscription flow works end to end, the entitlement state is reliable, and the pricing surface is clear.

**Done when:** A fresh install can reach the paywall, load offerings, buy or restore a subscription, and return to the app with the right entitlement state without manual intervention.

### Phase 4: Expand Features for Pro

**Goal:** Add meaningful paid depth without damaging the free experience.

- Add features that logically extend the current app: richer archives, advanced filters, curated paths, deeper context, and more personalization.
- Gate the right advanced features behind Pro while keeping the core daily experience free and useful.
- Build feature bundles that justify the subscription, rather than piecemeal paywalls.
- Extend content, learning paths, or premium tools only after the free core remains stable.
- Prepare post-launch iteration based on usage and conversion data.

**Exit criteria:** Pro offers a clear upgrade path with enough depth to justify the subscription, and free users still get a complete product.

**Done when:** At least one Pro bundle feels substantial, is reflected in navigation and copy, and does not degrade the free daily reading flow.

### Pro Bundle 1: Depth and Control

**Goal:** Turn the current app into a deeper reading tool without taking value away from the free daily experience.

- Premium archive filters: lock advanced filters, multi-criteria sorting, and wider result views behind Pro.
- Deeper context cards: add extended explanation, related thinkers, and source context for Pro users on quote detail screens.
- Curated reading paths: provide a small set of guided reading paths that connect quotes, facts, and thinkers into sequences.
- Personalization controls: allow Pro users to tune what appears first in the feed, while free users keep the default curated flow.
- Navigation entry points: surface Pro access from the paywall, settings, and select context-heavy screens instead of hiding it in a separate corner.

**Screen targets:** [lib/presentation/archive](lib/presentation/archive), [lib/presentation/detail](lib/presentation/detail), [lib/presentation/thinkers](lib/presentation/thinkers), [lib/presentation/paywall](lib/presentation/paywall), [lib/presentation/settings](lib/presentation/settings).

**Success criteria:** The bundle can be explained in one sentence, each Pro feature maps to an existing app surface, and the free app still feels complete.

## 5. Launch Order

1. Stabilize core flows and remove known bugs.
2. Polish the main UI surfaces.
3. Verify monetization from offer loading to entitlement activation.
4. Add or finalize Pro-only features.
5. Run release candidate testing on Android and iOS.
6. Freeze scope, fix only launch blockers, and ship.

## 6. Current Focus

- UI polish is the active track.
- The next code targets are the remaining utility-heavy screens, especially detail-adjacent surfaces and any rough edges that still stand out in the premium and settings flows.
- Quiz, onboarding, favorites, and archive now share the newer editorial intro treatment and are closer to the same visual language as home.
- Monetization work stays queued until the UI pass stops changing the purchase story.

## 7. What Not To Do Before Launch

- Do not start broad feature expansion before the app is stable.
- Do not add new premium ideas before the current paywall and subscription path are reliable.
- Do not keep multiple competing documentation drafts for the same roadmap.
- Do not let UI polish hide unresolved functional issues.

## 8. Files to Keep

- `README.md`
- `FIREBASE_SETUP.md`
- `REVENUECAT_SETUP.md`
- `ADMOB_SETUP.md`
- `AFFILIATE_SETUP.md`
- `MONETIZATION_OPTIONS_RESEARCH.md`
- `PREMIUM_FEATURE_ROADMAP.md`
- `PERFORMANCE_ANALYSIS.md`
- `PERFORMANCE_OPTIMIZATION.md`
- `PAYWALL_STYLE_SPEC.md`
- `LOGIN_AUTH_STRATEGY.md`

## 9. Files Removed as Outdated

- `CONTENT_EXPANSION_PLAN_TEMP.md`
- `FEATURE_DEEP_DIVE_TEMP.md`
- `FEATURE_GAMIFICATION_TEMP.md`
- `FEATURE_LEARNING_PATHS_TEMP.md`
- `DOCUMENTATION_SETUP_SUMMARY.md`
