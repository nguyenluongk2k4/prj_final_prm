# Reels Audio Tab Visibility Bugfix Design

## Overview

Audio from the Reels page continues playing when the user switches to a different bottom-navigation tab. The fix targets five root causes across three files: `ReelsStore`, `ReelsPage`, and `ReelCard`. The approach is minimal — each change either removes a conflicting signal, guards an unconditional call, or corrects a wrong default — so that a single authoritative visibility source drives all audio state.

## Glossary

- **Bug_Condition (C)**: The set of conditions under which audio plays despite the Reels tab being hidden from the user
- **Property (P)**: The desired invariant — audio MUST NOT play when `isReelsPageVisible == false`
- **Preservation**: All existing audio behavior while the Reels tab IS visible must remain unchanged
- **isReelsPageVisible**: The `@observable bool` in `ReelsStore` (`lib/features/home/presentation/stores/reels_store.dart`) that gates all audio operations
- **_isPageVisible**: The local `bool` field in `_ReelsPageState` (`lib/features/home/presentation/pages/reels_page.dart`) that tracks whether the page is currently shown in the `IndexedStack`
- **globalResume()**: The `ReelsStore` action that resumes audio for the currently focused reel — only safe to call when `isReelsPageVisible == true`
- **setPageVisibility(bool)**: The `ReelsStore` action that updates `isReelsPageVisible` and triggers audio start/stop accordingly
- **outer VisibilityDetector**: The `VisibilityDetector` with key `reels_page_container_vis` wrapping the entire `AppScaffold` — the single authoritative source of page-level visibility
- **inner VisibilityDetector**: The `VisibilityDetector` with key `reels_page_vis` inside `body:` — the conflicting detector that must be removed

## Bug Details

### Bug Condition

The bug manifests when any of five conditions allow audio to play while the Reels tab is not the active bottom-navigation tab. The `isReelsPageVisible` flag is either initialized incorrectly, overwritten by a conflicting detector, or bypassed by unconditional resume calls.

**Formal Specification:**
```
FUNCTION isBugCondition(state)
  INPUT: state of type AppState {
    isReelsTabActive: bool,
    isReelsPageVisible: bool,
    audioPlayerState: PlayerState,
    appLifecycleState: AppLifecycleState,
    reelCardVisibleFraction: double
  }
  OUTPUT: boolean

  // Root cause 1: wrong default allows audio before page is ever shown
  IF state.isReelsPageVisible == true AND state.isReelsTabActive == false
    RETURN true

  // Root cause 2: inner VisibilityDetector overrides outer with setPageVisibility(true)
  IF innerDetectorFiredTrue AND outerDetectorFiredFalse
    RETURN true

  // Root cause 3: app resume unconditionally resumes audio
  IF state.appLifecycleState == resumed
     AND state.isReelsTabActive == false
     AND globalResumeCalledUnconditionally
    RETURN true

  // Root cause 4: ReelCard calls globalResume() without checking page visibility
  IF state.reelCardVisibleFraction > 0.1
     AND state.isReelsPageVisible == false
     AND globalResumeCalledFromCard
    RETURN true

  RETURN false
END FUNCTION
```

### Examples

- App launches, user is on the Home tab: `isReelsPageVisible` defaults to `true` → `fetchReels` auto-focuses reel[0] and calls `_handleAudioFocus()` → audio starts on a hidden page
- User is watching a reel, switches to the Map tab: outer detector fires `setPageVisibility(false)`, but inner detector (threshold 0.8) fires `setPageVisibility(true)` shortly after → audio continues
- User backgrounds the app while on the Map tab, then foregrounds it: `didChangeAppLifecycleState(resumed)` calls `setPageVisibility(true)` and `globalResume()` unconditionally → audio starts on a hidden page
- User is on the Map tab, a `ReelCard` scrolls into its own viewport fraction > 0.1: card's `VisibilityDetector` calls `globalResume()` directly → audio leaks through

## Expected Behavior

### Preservation Requirements

**Unchanged Behaviors:**
- Scrolling between reels while on the Reels tab must continue to play audio for the focused reel and pause for reels scrolling out of view
- Backgrounding the app while on the Reels tab must continue to pause audio on `AppLifecycleState.paused` / `inactive`
- Foregrounding the app while on the Reels tab must continue to resume audio for the focused reel
- Switching between "Bạn bè" and "Khám phá" feed tabs within the Reels page must continue to stop audio and reload the feed
- Reels without an `audioUrl` must continue to play video silently without attempting to start the audio player

**Scope:**
All inputs that do NOT involve the Reels tab being hidden should be completely unaffected by this fix. This includes:
- All audio behavior while `isReelsPageVisible == true`
- Video playback via `VideoPlayerController` (unaffected — only `globalResume()` / `globalPause()` / `stopAudio()` are guarded)
- Like, comment, and upload interactions

## Hypothesized Root Cause

1. **Wrong Default Value**: `isReelsPageVisible = true` in `ReelsStore` means the store considers the page visible from the moment the singleton is created — before the user has ever navigated to the Reels tab. `fetchReels` then auto-focuses and calls `_handleAudioFocus()` on first load, starting audio immediately.

2. **Conflicting VisibilityDetectors**: Two detectors both call `setPageVisibility`:
   - Outer (`reels_page_container_vis`) wraps the whole scaffold — fires correctly on tab switch
   - Inner (`reels_page_vis`) is inside `body:` with a 0.8 threshold — fires `setPageVisibility(true)` when the body content is still partially visible during the tab-switch animation, overriding the outer detector's `false` signal

3. **Unconditional App Resume**: `didChangeAppLifecycleState` calls `_store.setPageVisibility(true)` and `_store.globalResume()` whenever `AppLifecycleState.resumed` fires, regardless of whether `_isPageVisible` is `true`. Since `_ReelsPageState` is kept alive by `AutomaticKeepAliveClientMixin`, this observer fires even when the Reels tab is not active.

4. **ReelCard Bypasses Page Guard**: `ReelCard`'s `VisibilityDetector.onVisibilityChanged` calls `widget.store.globalResume()` directly when `visibleFraction > 0.1`. Although `globalResume()` internally checks `isReelsPageVisible`, the call path from the card does not — and if `isReelsPageVisible` is incorrectly `true` (due to root cause 1 or 2), audio leaks.

5. **dispose() Never Called**: `AutomaticKeepAliveClientMixin` (`wantKeepAlive = true`) keeps `_ReelsPageState` alive across tab switches, so `dispose()` — which calls `stopAudio()` — is never reached during normal tab navigation.

## Correctness Properties

Property 1: Bug Condition - Audio Stops When Reels Tab Is Hidden

_For any_ app state where the Reels tab is not the active bottom-navigation tab (`_isPageVisible == false`), the fixed code SHALL ensure `isReelsPageVisible == false` and `_globalAudioPlayer.state != PlayerState.playing`. No code path — including app lifecycle resume, `ReelCard` visibility changes, or `fetchReels` auto-focus — SHALL start or resume audio when this condition holds.

**Validates: Requirements 2.1, 2.2, 2.4, 2.5**

Property 2: Preservation - Audio Behavior Unchanged When Reels Tab Is Active

_For any_ app state where the Reels tab IS the active bottom-navigation tab (`_isPageVisible == true` and `isReelsPageVisible == true`), the fixed code SHALL produce exactly the same audio behavior as the original code: playing audio for the focused reel, pausing on background, resuming on foreground, and stopping on feed-type change.

**Validates: Requirements 3.1, 3.2, 3.3, 3.4, 3.5**

## Fix Implementation

### Changes Required

**Fix 1 — ReelsStore: correct default value**

File: `lib/features/home/presentation/stores/reels_store.dart`

```dart
// BEFORE
@observable
bool isReelsPageVisible = true;

// AFTER
@observable
bool isReelsPageVisible = false;
```

This prevents `fetchReels` from auto-playing audio before the page is ever shown. The existing guard `if (isReelsPageVisible && currentActiveReelId == null && reels.isNotEmpty)` in `fetchReels` already handles this correctly once the default is `false`.

---

**Fix 2 — ReelsPage: remove the inner VisibilityDetector**

File: `lib/features/home/presentation/pages/reels_page.dart`

Remove the `VisibilityDetector` with key `reels_page_vis` that wraps the `body:` content. The `PageView.builder` (and its loading/error/empty states) should be the direct child of `body:` instead. The outer `VisibilityDetector` with key `reels_page_container_vis` (which wraps the entire `AppScaffold`) remains as the single authoritative source.

```dart
// BEFORE — body: wraps content in a second VisibilityDetector
body: VisibilityDetector(
  key: const Key('reels_page_vis'),
  onVisibilityChanged: (info) {
    final isVisible = info.visibleFraction > 0.8;
    _store.setPageVisibility(isVisible);
  },
  child: Observer(builder: (_) { ... }),
),

// AFTER — body: directly contains the Observer
body: Observer(builder: (_) { ... }),
```

---

**Fix 3 — ReelsPage: guard `didChangeAppLifecycleState` on `_isPageVisible`**

File: `lib/features/home/presentation/pages/reels_page.dart`

```dart
// BEFORE
} else if (state == AppLifecycleState.resumed) {
  debugPrint('ReelsPage: App resumed');
  _store.setPageVisibility(true);
  _store.globalResume();
}

// AFTER
} else if (state == AppLifecycleState.resumed) {
  debugPrint('ReelsPage: App resumed');
  if (_isPageVisible) {
    _store.setPageVisibility(true);
    _store.globalResume();
  }
}
```

---

**Fix 4 — ReelCard: guard `globalResume()` behind `store.isReelsPageVisible`**

File: `lib/features/home/presentation/widgets/reel_card.dart`

```dart
// BEFORE
} else if (info.visibleFraction > 0.1) {
  if (widget.shouldPlay && !widget.reel.isPhoto) {
    _controller?.play();
  } else if (widget.shouldPlay && widget.reel.isPhoto && widget.reel.audioUrl != null) {
    widget.store.globalResume();
  }
}

// AFTER
} else if (info.visibleFraction > 0.1) {
  if (widget.shouldPlay && !widget.reel.isPhoto) {
    _controller?.play();
  } else if (widget.shouldPlay && widget.reel.isPhoto && widget.reel.audioUrl != null
      && widget.store.isReelsPageVisible) {
    widget.store.globalResume();
  }
}
```

---

**Fix 5 — ReelsStore: `fetchReels` auto-play guard (no change needed)**

The existing guard `if (isReelsPageVisible && currentActiveReelId == null && reels.isNotEmpty)` in `fetchReels` is already correct. Once Fix 1 sets the default to `false`, this guard will correctly prevent auto-play on first load. No code change required here.

## Testing Strategy

### Validation Approach

The testing strategy follows a two-phase approach: first, surface counterexamples that demonstrate the bug on unfixed code to confirm root cause analysis; then verify the fix works correctly and preserves existing behavior.

### Exploratory Bug Condition Checking

**Goal**: Surface counterexamples that demonstrate the bug BEFORE implementing the fix. Confirm or refute the root cause analysis. If we refute, we will need to re-hypothesize.

**Test Plan**: Write unit tests that directly manipulate `ReelsStore` state and call the relevant methods, asserting that `_globalAudioPlayer.state` is NOT `PlayerState.playing` after the bug-triggering sequence. Run these tests on the UNFIXED code to observe failures.

**Test Cases**:
1. **Default Visibility Test**: Create a fresh `ReelsStore`, call `fetchReels()` with mock data — assert `_globalAudioPlayer.state != PlayerState.playing` (will fail on unfixed code because `isReelsPageVisible` defaults to `true`)
2. **App Resume Without Tab Active Test**: Set `isReelsPageVisible = false`, simulate `didChangeAppLifecycleState(resumed)` path by calling `setPageVisibility(true)` + `globalResume()` unconditionally — assert audio does NOT play (will fail on unfixed code)
3. **ReelCard Resume Bypass Test**: Set `isReelsPageVisible = false`, call `globalResume()` directly — assert `_globalAudioPlayer.state != PlayerState.playing` (this already passes because `globalResume()` checks `isReelsPageVisible`; confirms the card guard is the issue, not the store method itself)
4. **Conflicting Detector Test**: Call `setPageVisibility(false)` then immediately `setPageVisibility(true)` — assert audio stops (simulates the inner detector overriding the outer)

**Expected Counterexamples**:
- `fetchReels` starts audio on a store with `isReelsPageVisible = true` (the wrong default)
- Unconditional `setPageVisibility(true)` + `globalResume()` on app resume starts audio regardless of tab state

### Fix Checking

**Goal**: Verify that for all inputs where the bug condition holds, the fixed code produces the expected behavior (audio stopped, `isReelsPageVisible == false`).

**Pseudocode:**
```
FOR ALL state WHERE isBugCondition(state) DO
  result := applyFixedCode(state)
  ASSERT result.audioPlayerState != PlayerState.playing
  ASSERT result.isReelsPageVisible == false
END FOR
```

### Preservation Checking

**Goal**: Verify that for all inputs where the bug condition does NOT hold (Reels tab is active), the fixed code produces the same audio behavior as the original code.

**Pseudocode:**
```
FOR ALL state WHERE NOT isBugCondition(state) AND state.isReelsTabActive == true DO
  ASSERT fixedCode(state).audioPlayerState == originalCode(state).audioPlayerState
END FOR
```

**Testing Approach**: Property-based testing is recommended for preservation checking because:
- It generates many random reel configurations and scroll positions automatically
- It catches edge cases (e.g., reels with no audio, rapid scroll, feed-type switches) that manual tests miss
- It provides strong guarantees that behavior is unchanged for all non-buggy inputs

**Test Cases**:
1. **Scroll Preservation**: With `isReelsPageVisible = true`, call `setCurrentIndex(n)` for various indices — assert audio plays for focused reel and pauses for others (same as before fix)
2. **Background/Foreground Preservation**: With `isReelsPageVisible = true`, call `setPageVisibility(false)` then `setPageVisibility(true)` — assert audio resumes correctly
3. **Feed Switch Preservation**: With `isReelsPageVisible = true`, call `setFeedType(ReelsFeedType.friends)` — assert audio stops and feed reloads
4. **No Audio URL Preservation**: With a reel that has `audioUrl == null`, assert no audio player calls are made regardless of visibility state

### Unit Tests

- Test that `isReelsPageVisible` initializes to `false` in a fresh `ReelsStore`
- Test that `fetchReels` does NOT auto-play when `isReelsPageVisible == false`
- Test that `globalResume()` is a no-op when `isReelsPageVisible == false`
- Test that `setPageVisibility(false)` stops audio and `setPageVisibility(true)` resumes it
- Test that `didChangeAppLifecycleState(resumed)` with `_isPageVisible == false` does NOT call `setPageVisibility(true)`
- Test edge cases: `setCurrentIndex` out of bounds, empty reels list, reel with null `audioUrl`

### Property-Based Tests

- Generate random sequences of `setCurrentIndex` calls with `isReelsPageVisible = true` and verify audio always plays for the focused reel
- Generate random `isReelsPageVisible` toggle sequences and verify audio state is always consistent with the final visibility value
- Generate random reel lists (mix of photo/video, with/without audio) and verify `reelMusicMap` is populated correctly and audio only plays for mapped reels

### Integration Tests

- Full tab-switch flow: navigate to Reels tab → audio starts → switch to Home tab → assert audio stops → switch back to Reels tab → assert audio resumes
- App lifecycle flow: on Reels tab → background app → assert audio pauses → foreground app → assert audio resumes; repeat with a non-Reels tab active and assert audio does NOT resume
- Feed switch flow: on Reels tab → switch feed type → assert audio stops → new feed loads → assert audio starts for first reel
