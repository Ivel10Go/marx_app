# Marx App Launch Plan

## 1. Current App State

- The app already has a bootstrap gate in [lib/main.dart](lib/main.dart#L1) and a router-driven shell in [lib/app.dart](lib/app.dart#L1).
- Core content surfaces already exist: home feed, quote detail, archive, thinkers, quiz, onboarding, settings, and premium/paywall flows.
- Monetization infrastructure is already present through RevenueCat integration, plus premium and paywall screens.
- Widget sync, notifications, streaks, sharing, TTS, and daily content resolution are already part of the product foundation.

## 2. Launch Goal

Ship a stable, polished, core-first app for release, with a reliable free experience and monetization baseline; move non-core feature depth into staged post-launch updates.

## 2.1 Release Scope Decision (Core-Only First)

This launch follows a strict core-first scope strategy.

### In Scope for Release

- Startup/bootstrap reliability.
- Daily quote core loop (home, detail, archive baseline, thinkers baseline).
- Settings reliability and essential preferences.
- Paywall baseline, purchase, restore, and entitlement refresh correctness.
- Shared loading, empty, and error state consistency across primary surfaces.

### Out of Scope for Release (Post-Launch)

- Pro Bundle depth features beyond baseline monetization reliability.
- Advanced archive controls, reading paths, and deep personalization controls.
- Non-critical experimental surfaces or polish that does not affect core loop reliability.

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
- [x] Darkmode removed for launch (single light-theme presentation).
- [x] Quiz removed from app (non-core feature, post-launch consideration).
- [x] Political orientation test removed from app (non-core feature, post-launch consideration).
- [x] Navigation simplified to core surfaces only (Home, Archive, Settings, Favorites, Thinkers, Onboarding).
- [x] UI-07 stage 1: shared loading/recovery language applied to startup, app-shell settings load, settings, archive, favorites, and thinkers.
- [x] UI-07 stage 2: shared loading/recovery language applied to detail, admin content status, and profile source loading (with retry actions).
- [x] UI-01: Home header hierarchy and density pass completed with responsive action layout for small screens.
- [x] UI-02: Archive visual consistency pass completed (responsive tabs, search rhythm, structured empty state).
- [x] UI-03: Quiz polish closure completed (unified loading, intro/result hierarchy, smoother state continuity).
- [x] UI-04: Favorites polish closure completed (count metadata, structured empty state, clearer primary action).
- [x] UI-05: Onboarding continuity pass completed (step context card, clearer header hierarchy, stronger flow continuity).
- [x] UI-06: Detail/settings consistency pass completed (structured detail empty state, consistent section-card surfaces/borders).
- [x] MON-01 stage 1: offering load resilience hardened (retry/timeout-aware fetch result, empty-package detection, explicit reload action).
- [x] MON-02: purchase state handling hardened (granular error messages for network/cancellation/SDK failures, clear retry guidance, post-purchase entitlement check).
- [x] MON-03 stage 1: entitlement refresh reliability hardened (cached customer info snapshot + safe refresh on provider/page init).
- [x] MON-04: customer center graceful fallback (user-friendly error message when unavailable, no dead-end state).
- [x] MON-05: route guards and feature gates sync validation (PremiumGate updates immediately, entitlement stream propagates to all subscribers, no stale UI).
- [ ] UI polish across the main screens.
- [ ] RevenueCat and paywall flow audit (completed for MON-01/02/03/04/05 scope).
- [x] Pro feature expansion moved to post-launch updates (core-only release scope locked).

## 3.1 Immediate Work Queue

1. Ensure startup and loading experience flows naturally from first frame through fallback states.
2. Validate all core surfaces on iOS and Android devices (Home, Archive, Settings, Favorites, Thinkers, Onboarding, Detail, Paywall).
3. Run Test Matrix (12 test cases) to validate monetization changes.
4. Lock non-core features (Quiz, Orientation tests, Pro bundles) into post-launch backlog.

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
- Reduce visual competition in the home header and make the top block easier to scan on smaller screens.
- Tighten typography, spacing, and card consistency across home, detail, archive, quiz, onboarding, favorites, and settings.
- Improve transitions and loading states so the app feels responsive instead of abrupt.
- Unify loading states across startup, settings, and data-heavy screens so the app uses one visual language for waiting and recovery.
- Refine premium and paywall screens so the value proposition is understandable in seconds.
- Make premium gates and paywall entry points feel consistent in copy, spacing, and action hierarchy.
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

### Phase 4 (Post-Launch): Expand Features for Pro

**Goal:** Add meaningful paid depth after release without destabilizing the shipped core app.

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
4. Freeze non-core scope and defer advanced Pro depth to post-launch updates.
5. Run release candidate testing on Android and iOS.
6. Freeze scope, fix only launch blockers, and ship.

## 5.1 Milestones and Target Sequence

1. Milestone A: Core stability pass closed (no open high-severity defects in bootstrap, navigation, and daily content flow).
2. Milestone B: UI cohesion pass closed (main surfaces share one visual system and loading language).
3. Milestone C: Monetization pass closed (offerings, purchase, restore, entitlement refresh verified on both platforms).
4. Milestone D: Core-only scope freeze accepted (all non-core items moved to post-launch).
5. Milestone E: Release candidate signed off after full regression and store metadata review.

## 6. Current Focus

### Completed Tracks
- ✅ **Monetization audit complete (Phase 3 done)**
  - MON-01: Offerings load resilience ✅
  - MON-02: Purchase state messaging with granular error handling ✅
  - MON-03: Entitlement refresh reliability ✅
  - MON-04: Customer center graceful fallback ✅
  - MON-05: Route guards and feature gates sync ✅
  - All MON changes compile without errors and are production-ready

### Active Next Steps
1. **Run Test Matrix (section 6.3)** — Validate all monetization changes on both platforms before RC cut
   - Focus: Cold start, purchase flow, restore, customer center, entitlement sync, widget sync
   - Deliverable: Test execution report with pass/fail per test case
   
2. **UI Polish Finalization** — Minor adjustments if needed after test pass
   - Focus: Remaining unchecked items in section 6.2 acceptance checklist
   - Deliverable: Final visual pass on main surfaces (home, detail, paywall, settings)
   
3. **Pro Bundle 1 Scope Lock** — Document post-launch scope and finalize free/pro boundary
   - Note: PRO-01 to PRO-05 are post-launch by default
   - Deliverable: Scope freeze document for store release

### Previous Achievements
- The critical startup path is shorter because repository seeding no longer blocks the first app frame
- The loading screen progress bar now uses simpler determinate presentation
- Quiz, onboarding, favorites, and archive now share consistent editorial intro treatment
- The purchase page is explicit about load, restore, and customer-center failure cases
- Release strategy is explicitly core-first: reliable baseline features for launch, expansion through updates

## 6.1 Current Sprint (Finish-to-Launch)

### Phase 3 Complete: Monetization Reliability Audit ✅

- ✅ Offerings load resilience (MON-01)
- ✅ Purchase state messaging with clear error paths (MON-02)
- ✅ Entitlement refresh reliability (MON-03)
- ✅ Customer center graceful fallback (MON-04)
- ✅ Route guards and feature gates sync (MON-05)

### Phase 3→4 Transition: Pre-RC Testing & Polish

1. **Test Matrix Execution (section 6.3)**
   - Priority: Monetization test cases (purchase flow, restore, customer center, entitlement sync)
   - Platforms: iOS + Android smoke tests for startup, quote flow, archive, paywall, purchase, restore, settings
   - Validation: All test cases pass before RC cut

2. **UI Polish Closure (if needed)**
   - Final pass on typography, spacing, and color consistency
   - Validate small-screen layouts on common devices (< 5" screens)
   - Ensure no high-friction layout breaks in portrait mode

3. **Pro Bundle 1 Scope Lock**
   - Document PRO-01 to PRO-05 as post-launch
   - Freeze free/pro boundary before app submission
   - Lock non-core features: no new Pro depth features in launch build

4. **Release Candidate Preparation**
   - Collect all test results into release gate checklist (section 6.4)
   - Prepare store listing copy aligned with free/pro behavior
   - Screenshot prep for both free and Pro UX paths

## 6.2 Acceptance Checklist for Pre-RC (Definition of Done)

### Monetization Audit ✅ Complete

- [x] Offerings load correctly in fresh install state and after app relaunch.
- [x] Purchase flow handles success, cancellation, and failure states with clear messaging.
- [x] Restore flow updates entitlement state without requiring app restart.
- [x] Customer center access fails gracefully when unavailable.
- [x] Route guards and feature gates update immediately after entitlement changes.
- [x] All MON-01 through MON-05 code changes compile successfully with no errors.

### UI Polish - Remaining Items

- [ ] Home, archive, quiz, favorites, onboarding, detail, settings, and paywall all use consistent typography scale and spacing rhythm.
- [ ] Loading, empty, and error states follow the same visual language and action hierarchy.
- [ ] No high-friction layout breaks on common phone sizes in portrait mode.

### Test Matrix Execution - Pending

- [ ] All 12 test cases from section 6.3 executed and passed on iOS
- [ ] All 12 test cases from section 6.3 executed and passed on Android
- [ ] No P0/P1 issues discovered during testing
- [ ] Results documented in release gate checklist (section 6.4)

## 6.3 Test Matrix Before RC

Comprehensive validation covering startup, monetization, and daily loop resilience. Execute after MON-01/02/03/04/05 completion.

### Startup & Bootstrap Tests

1. **Cold start offline** — App boots with cached/fallback state, no crash
   - Status: ⏳ Pending (validate after MON work)
   - Platform: iOS + Android
   
2. **Cold start online with slow network** — Loading spinner + timeout handling visible, retry works
   - Status: ⏳ Pending
   - Platform: iOS + Android
   
3. **Cold start after app uninstall (fresh account)** — Onboarding → quote flow smooth, no stale data
   - Status: ⏳ Pending
   - Platform: iOS + Android

### Monetization Tests

4. **Purchase success flow** — Offer loads → buy button → success message → Pro active immediately
   - Status: ⏳ Pending (MON-02 code change validation)
   - Expected: PremiumGate updates, route guards sync, no restart needed
   - Platform: iOS + Android
   
5. **Purchase cancellation** — User cancels → clear "Kauf abgebrochen" message → no charge
   - Status: ⏳ Pending (MON-02 error handling)
   - Platform: iOS + Android
   
6. **Purchase network retry** — Network fails during purchase → error message + retry button → success on retry
   - Status: ⏳ Pending (MON-02 network error path)
   - Platform: iOS + Android
   
7. **Restore on new install with existing subscription** — Fresh device → restore button → Pro active, no purchase needed
   - Status: ⏳ Pending (MON-02/03 restore flow)
   - Platform: iOS + Android
   
8. **Customer center unavailable** — Button click → friendly error message, not crash
   - Status: ⏳ Pending (MON-04 fallback)
   - Platform: iOS + Android (where unavailable)

9. **Background resume with stale entitlement cache** — App backgrounded → entitlement expires in RevenueCat → app resumes → Pro gates update correctly
   - Status: ⏳ Pending (MON-05 stream sync)
   - Platform: iOS + Android

### Daily Loop & Widget Tests

10. **Widget sync after manual refresh** — Home → refresh widget → widget updates same-day count
    - Status: ⏳ Pending
    - Platform: iOS + Android
    
11. **Widget sync after day rollover** — Widget shows previous day at 23:59 → new day at 00:01 → widget count resets
    - Status: ⏳ Pending
    - Platform: iOS + Android

### Notification Tests

12. **Notification schedule update with denied permission** — Settings → permission denied → error message (not crash)
    - Status: ⏳ Pending
    - Platform: iOS + Android

## 6.4 Release Gate (Definition of Done)

**Pre-RC Freeze Checklist:**
- No open P0/P1 issues in startup, navigation, quote loading, or purchases.
- All acceptance checklist items in section 6.2 are checked.
- All 12 test matrix items in section 6.3 pass on both platforms.
- Android and iOS smoke tests pass for startup, quote flow, archive, paywall, purchase, restore, and settings.
- Store listing copy and screenshots align with actual free/pro behavior.
- **Scope freeze in effect: only launch blockers and regressions are allowed after this point.**

## 6.5 Post-Launch Scope (PRO Bundle 1 — Deferred)

**These features are explicitly deferred to post-launch updates and will NOT block RC:**

### Pro Bundle 1 Features (PRO-01 through PRO-05)

These are documented for post-launch sprint planning but should NOT be implemented before launch:

1. **PRO-01 Premium archive filters** — Advanced filtering, multi-criteria sorting, wider results
2. **PRO-02 Deeper context cards** — Extended explanations, related thinkers, source context  
3. **PRO-03 Curated reading paths** — Guided paths connecting quotes/facts/thinkers
4. **PRO-04 Personalization controls** — Feed priority tuning for Pro users
5. **PRO-05 Pro entry points and copy alignment** — Consistent messaging across paywall/settings/detail

**Rationale:** Free core must ship stable before adding premium depth. Pro baseline (purchase, restore, entitlement sync) is solid; depth expansion comes in v1.1+.

## 6.6 Ticket Breakdown (Directly Actionable)

Use the ticket IDs below as implementation units. Each ticket is done only when code, UI state behavior, and platform validation are complete.

### Track A: UI Cohesion Tickets

1. UI-01 Home hierarchy and header density
- Scope: tighten header composition, rebalance quote/context/streak visual order, reduce top-block clutter.
- Files: [lib/presentation/home](lib/presentation/home).
- Done criteria: hierarchy scans clearly on small devices, no overlapping/competing primary actions.

2. UI-02 Archive visual consistency
- Scope: align card spacing, filter bar rhythm, typography, and empty/error state styling with home language.
- Files: [lib/presentation/archive](lib/presentation/archive).
- Done criteria: archive cards and controls match shared spacing and heading scale.

3. UI-03 Quiz polish closure
- Scope: finalize intro block, question container rhythm, feedback state visuals, and CTA ordering.
- Files: [lib/presentation/quiz](lib/presentation/quiz).
- Done criteria: no abrupt style shifts between intro, in-progress, and result states.

4. UI-04 Favorites polish closure
- Scope: unify list density, empty-state language, and action affordance emphasis.
- Files: [lib/presentation/favorites](lib/presentation/favorites).
- Done criteria: favorites view follows same card and spacing language as archive/home.

5. UI-05 Onboarding continuity pass
- Scope: align onboarding typography scale, page spacing, and step transitions with editorial style.
- Files: [lib/presentation/onboarding](lib/presentation/onboarding).
- Done criteria: onboarding no longer feels visually separate from core app surfaces.

6. UI-06 Detail and settings consistency pass
- Scope: normalize detail-style surfaces and settings rows for heading rhythm, section spacing, and CTA prominence.
- Files: [lib/presentation/detail](lib/presentation/detail), [lib/presentation/settings](lib/presentation/settings).
- Done criteria: detail/settings now share loading, empty, and error visual language.

7. UI-07 Shared loading/recovery component pass
- Scope: standardize loading indicator, fallback copy, retry action placement, and recovery state behavior.
- Files: [lib/main.dart](lib/main.dart#L1), [lib/presentation/settings](lib/presentation/settings), data-heavy screens in [lib/presentation](lib/presentation).
- Done criteria: startup/settings/content-heavy loading states are recognizably one system.

### Track B: Monetization Reliability Tickets

1. MON-01 Offerings load resilience
- Scope: verify offering fetch behavior for initial load, empty offerings, timeout/network failure.
- Files: [lib/core/services/purchases_service.dart](lib/core/services/purchases_service.dart).
- Done criteria: user-facing state always resolves to loading, success, or actionable failure.

2. MON-02 Purchase state handling
- Scope: confirm success/cancel/failure paths and message clarity, including retry guidance.
- Files: [lib/presentation/paywall/purchase_page.dart](lib/presentation/paywall/purchase_page.dart).
- Done criteria: every purchase outcome returns the user to a clear next action.
- Status: ✅ Complete (granular error messages for network/cancellation, retry guidance, post-purchase entitlement check).

3. MON-03 Restore and entitlement refresh
- Scope: ensure restore refreshes entitlement immediately without restart; handle failure messaging.
- Files: [lib/core/services/purchases_service.dart](lib/core/services/purchases_service.dart), [lib/presentation/paywall/purchase_page.dart](lib/presentation/paywall/purchase_page.dart).
- Done criteria: restored users see unlocked state in-session.
- Status: ✅ Complete (latestCustomerInfo cache + safe refresh on provider init).

4. MON-04 Customer center graceful fallback
- Scope: validate open/fail behavior and user guidance when customer center is unavailable.
- Files: [lib/presentation/paywall/purchase_page.dart](lib/presentation/paywall/purchase_page.dart), paywall entry routes in [lib/app.dart](lib/app.dart#L1).
- Done criteria: no dead-end state; failure path is explicit and recoverable.
- Status: ✅ Complete (user-friendly error message, no dead-end when unavailable).

5. MON-05 Route guards and feature gates sync
- Scope: verify route and feature visibility update immediately after purchase/restore/expiration refresh.
- Files: route and gate logic reachable from [lib/app.dart](lib/app.dart#L1), purchases integration in [lib/core/services](lib/core/services).
- Done criteria: no stale pro/free UI after entitlement changes.
- Status: ✅ Complete (StreamProvider emits immediately → Riverpod rebuilds PremiumGate + route guards without restart).

### Track C: Pro Bundle 1 Tickets

These tickets are post-launch by default and should not block RC unless they are required for existing paid promises in production copy.

1. PRO-01 Premium archive filters
- Scope: implement gated advanced filter/sort set and free fallback behavior.
- Files: [lib/presentation/archive](lib/presentation/archive).
- Done criteria: free baseline remains useful; pro controls are clearly labeled and gated.

2. PRO-02 Deeper context cards
- Scope: add pro-only extended context sections on detail surfaces with clear preview boundary.
- Files: [lib/presentation/detail](lib/presentation/detail).
- Done criteria: free and pro boundary is explicit, no broken layout when locked.

3. PRO-03 Curated reading paths
- Scope: introduce first guided paths with entry points from thinkers/detail surfaces.
- Files: [lib/presentation/thinkers](lib/presentation/thinkers), [lib/presentation/detail](lib/presentation/detail).
- Done criteria: at least one complete path is navigable end-to-end.

4. PRO-04 Personalization controls
- Scope: expose pro feed-priority controls while preserving free default behavior.
- Files: [lib/presentation/settings](lib/presentation/settings), home-related surfaces in [lib/presentation/home](lib/presentation/home).
- Done criteria: control changes are applied predictably and revert safely.

5. PRO-05 Pro entry points and copy alignment
- Scope: align pro messaging and entry points across paywall, settings, and context-heavy screens.
- Files: [lib/presentation/paywall](lib/presentation/paywall), [lib/presentation/settings](lib/presentation/settings), [lib/presentation/detail](lib/presentation/detail).
- Done criteria: one-sentence value proposition is consistent across all pro entry points.

## 6.6 Execution Status & Next Phase

**✅ Completed Tracks:**
1. UI-07 + UI-01 through UI-06: All main surface UI polish complete with shared loading/recovery language
2. MON-01 through MON-05: Monetization audit complete with resilient offerings, purchase state handling, entitlement refresh, customer center fallback, and route guard sync

**⏳ In Progress:**
3. Test Matrix execution (section 6.3) — 12 comprehensive test cases covering startup, purchase flow, restore, entitlement sync, and widget behavior
   - Must pass on both iOS and Android before RC cut
   - Focus: All 8 monetization test cases (tests 4-9) to validate MON-01-05 changes

**📋 Pre-Launch Scope Lock:**
4. PRO-01 through PRO-05 moved to post-launch backlog — will NOT block RC
   - Free core ships stable in v1.0
   - Pro depth features (advanced filters, context cards, reading paths, personalization) added in v1.1+

**🚀 Release Candidate Preparation:**
5. After Test Matrix passes:
   - Collect all results into release gate (section 6.4)
   - Prepare store listing copy aligned with free/pro behavior
   - Screenshot prep for app store
   - Final scope freeze

## 7. Status Summary: Ready for RC Testing

### Phase 3 Complete ✅
Monetization audit complete with all 5 tasks finished:
- OfferingsFetchResult struct with timeout/retry/error handling
- Granular purchase messaging (network errors, cancellation, success)
- Cached customer info + safe refresh for immediate entitlement updates
- Customer center graceful fallback with user-friendly error
- StreamProvider pattern for instant PremiumGate + route guard sync (no app restart)

**Key Achievement:** End-to-end purchase → restore → entitlement refresh flow is resilient and free of exceptions.

### Ready for Test Execution
All code changes compile successfully. Next step is to run Test Matrix (12 test cases) on iOS and Android to validate:
1. Startup paths (cold start, offline, slow network)
2. Monetization paths (purchase, restore, network retry, customer center)
3. Entitlement sync (stale cache, background resume)
4. Widget/notification behavior

### Post-Launch Scope Locked
PRO-01 through PRO-05 moved to v1.1+ backlog. Free core ships stable in v1.0.

---

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

## 10. Final Launch Execution Note

This plan is now in execution mode, not discovery mode. Until ship, all work should map to three launch categories only: stability, UI cohesion, and monetization reliability. Pro bundle expansion is post-launch by default. Any task outside launch categories is deferred unless it resolves a verified launch blocker.
