# Test Runbook: Marx App Payment Flow Testing

## Purpose
Guide for comprehensive payment testing across iOS and Android before launch.

## Prerequisites
- ✅ iOS test account created in App Store Connect (TestFlight)
- ✅ Android test account created in Google Play Console
- ✅ Internal test track published with current build
- ✅ RevenueCat offerings configured for both platforms
- ✅ Test devices running current build

## iOS Payment Testing (TestFlight Sandbox)

### 1. Fresh Install Scenario
**Objective:** Verify first-time user flow to pro features

**Steps:**
1. Uninstall app completely
2. Open TestFlight on iOS device
3. Tap app → Install
4. Allow push notifications (if prompted)
5. Open app → should see home screen with free content
6. Tap "Premium" or paywall trigger button
7. Paywall displays → Offerings load (monthly + yearly shown)
8. Tap monthly plan ($4.99 US / €4.99 EU pricing)
9. Sandbox payment UI appears
10. Confirm payment with test account
11. Payment processes, app shows success message
12. Pro feature unlocks (Premium section visible, settings shows "✓ Pro")

**Expected Outcomes:**
- [ ] PaywallUI loads offerings in < 3 seconds
- [ ] Monthly/yearly prices display correctly for region
- [ ] Sandbox payment completes without actual charge
- [ ] Pro badge visible in Settings
- [ ] Can access premium quotes section

**Failure Scenarios to Test:**
- [ ] Network disabled during offering load → shows "retry" button
- [ ] Network disabled during payment → shows network error, payment reversed
- [ ] Kill app during payment → purchase still grants entitlement on restart

---

### 2. Subscription Management Scenario
**Objective:** Verify manage subscription flow in native App Store

**Steps:**
1. From app with active pro subscription
2. Open Settings → Tap "Manage Subscription"
3. iOS opens native subscription manager
4. Tap subscription → "Cancel Subscription"
5. Confirm cancellation
6. Return to app (don't kill)
7. Tap Settings → entitlement should still show Pro (grace period)
8. Wait 30 seconds
9. Pull down on app to refresh
10. Pro badge should disappear (after refresh from RevenueCat)

**Expected Outcomes:**
- [ ] Manage Subscription link opens native iOS UI
- [ ] Cancellation succeeds (no error)
- [ ] RevenueCat refresh detects cancellation within 30s
- [ ] UI updates to show non-Pro state

---

### 3. Restore Purchases Scenario
**Objective:** Verify cross-device restore on new test account

**Steps:**
1. Create NEW test account in App Store Connect (different email)
2. On Device A: Login with new account, install app
3. Device A: Tap paywall, purchase monthly plan
4. Device A: Verify pro badge appears
5. Uninstall app from Device A
6. On Device B: Same TestFlight app
7. Device B: Login with SAME test account (from step 1)
8. Device B: After install, open Settings → Tap "Restore Purchases"
9. App shows loading indicator
10. After restore completes, pro badge should appear

**Expected Outcomes:**
- [ ] Restore button is visible and clickable
- [ ] Restore completes in < 5 seconds
- [ ] Pro entitlement recognized on second device
- [ ] No error messages

---

### 4. Cold Start & Offline Scenarios

#### 4.1 Cold Start (New Installation)
1. Device offline (airplane mode)
2. Open TestFlight, install app
3. Launch app (still offline)
4. Should see home screen with cached free content (or "loading" state)
5. No crash, no blank screen

**Expected:** App loads cached data, doesn't hang

#### 4.2 Offline Purchase Attempt
1. Open paywall
2. Enable airplane mode
3. Tap "Purchase Monthly"
4. App shows network error, payment cancelled
5. Turn off airplane mode
6. Try purchase again
7. Should succeed

**Expected:** Graceful network error, retry succeeds

---

## Android Payment Testing (Internal Test Track)

### 1. Fresh Install Scenario (Google Play)
**Objective:** Same as iOS, Android version

**Steps:**
1. Uninstall app completely
2. Open internal test link (from Google Play Console)
3. Tap "Install" or open Play Store, tap app
4. Allow notifications
5. Open app
6. Tap paywall trigger
7. Google Play in-app billing UI appears
8. Select monthly plan (€3.99)
9. Tap "Continue" → Google Play processes payment
10. Return to app, success message shown
11. Pro badge appears in Settings

**Expected Outcomes:**
- [ ] Offerings load in < 3 seconds
- [ ] Google Play in-app purchase UI shows
- [ ] Payment processes without actual charge
- [ ] Pro entitlement syncs from Google Play to app
- [ ] Settings shows "✓ Pro"

---

### 2. Subscription Management (Google Play)
**Objective:** Verify cancellation through Play Store

**Steps:**
1. From app with active subscription
2. Settings → Tap "Manage Subscription"
3. Opens Google Play Store app to subscription details
4. Tap "Cancel subscription"
5. Select reason and confirm
6. Subscription cancellation processed
7. Return to app
8. Pull-to-refresh or wait 30s
9. Pro badge should disappear

**Expected Outcomes:**
- [ ] Link to Google Play subscription manager works
- [ ] Cancellation successful
- [ ] Entitlement removed after refresh (< 30s)

---

### 3. Restore Purchases (Android)
**Objective:** Cross-device restore with same Google Play account

**Steps:**
1. Create new Google test account
2. Device A: Sign in with test account, install app via internal track
3. Device A: Purchase monthly subscription
4. Device A: Uninstall
5. Device B: Sign in with same Google account, install app
6. Device B: Open Settings → Tap "Restore Purchases"
7. App shows loading
8. Pro badge appears after restore

**Expected Outcomes:**
- [ ] Restore completes in < 5 seconds
- [ ] Pro entitlement recognized
- [ ] No errors

---

### 4. Offline Testing (Android)
Same as iOS offline tests above.

---

## Error Scenarios & Edge Cases

### A. Network Failures
```
TEST: Offerings load timeout
- Open app with no internet
- Tap paywall
- Wait > 8 seconds (timeout threshold)
- EXPECT: "Offerings could not load. Please check connection." with Retry button
- Tap Retry after enabling network → Should load successfully
```

### B. Payment Failures
```
TEST: User cancels payment
- Tap purchase button
- Tap "Cancel" in payment sheet
- EXPECT: App shows "Purchase cancelled - no charge"
- No crash, Pro state unchanged
```

### C. RevenueCat Connection Issues
```
TEST: RevenueCat server error
- Simulate network block to RevenueCat (firewall/proxy)
- Purchase succeeds in Google Play/App Store
- EXPECT: Payment succeeds, entitlement eventually syncs via retry
- App should not crash, should show "Pro status updating..."
```

### D. Edge Case: App Backgrounded During Payment
```
TEST: App backgrounded → foregrounded during active transaction
- Tap purchase
- Immediately minimize app (home button)
- Wait 10 seconds
- Return to app
- EXPECT: Payment either completes or was cancelled
- No stale state, no UI hangs
```

---

## Success Criteria Summary

| Scenario | iOS ✓ | Android ✓ |
|----------|-------|-----------|
| Fresh install → purchase | [ ] | [ ] |
| Manage subscription → cancel | [ ] | [ ] |
| Restore on new device | [ ] | [ ] |
| Offline app load | [ ] | [ ] |
| Offline → online purchase retry | [ ] | [ ] |
| Network error handling | [ ] | [ ] |
| Cold start < 2s | [ ] | [ ] |
| Paywall load < 3s | [ ] | [ ] |

---

## Troubleshooting Quick Reference

### iOS Issues
- **Offerings blank**: Check RevenueCat → iOS → Offerings config
- **Sandbox payment fails**: Verify test account status in App Store Connect
- **Entitlement not syncing**: Check isProProvider refresh interval (should be < 30s)

### Android Issues
- **Offerings blank**: Verify Google Play product IDs in RevenueCat Dashboard
- **Internal track link doesn't work**: Regenerate from Google Play Console
- **Restore fails**: Ensure test account has prior purchase in same Google Play account

---

## Sign-Off
Testing completed: ________  (Date)
Tester: ________
Build Version: ________
Notes: ________
