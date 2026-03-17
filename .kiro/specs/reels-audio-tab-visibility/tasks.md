# Implementation Plan

- [ ] 1. Write bug condition exploration test
  - **Property 1: Bug Condition** - Audio Plays When Reels Tab Is Hidden
  - **CRITICAL**: This test MUST FAIL on unfixed code — failure confirms the bug exists
  - **DO NOT attempt to fix the test or the code when it fails**
  - **NOTE**: This test encodes the expected behavior — it will validate the fix when it passes after implementation
  - **GOAL**: Surface counterexamples that demonstrate the bug exists
  - **Scoped PBT Approach**: Scope the property to the four concrete root-cause scenarios for reproducibility
  - Create `test/features/home/presentation/stores/reels_store_bug_condition_test.dart`
  - Test case 1 — Default Visibility: create a fresh `ReelsStore`, call `fetchReels()` with mock data, assert `_globalAudioPlayer.state != PlayerState.playing` (fails because `isReelsPageVisible` defaults to `true`)
  - Test case 2 — App Resume Without Tab Active: set `isReelsPageVisible = false`, then call `setPageVisibility(true)` + `globalResume()` unconditionally (simulating the unfixed `didChangeAppLifecycleState` path), assert audio does NOT play
  - Test case 3 — Conflicting Detector: call `setPageVisibility(false)` then immediately `setPageVisibility(true)` (simulating inner detector overriding outer), assert `isReelsPageVisible == false` and audio is stopped
  - Test case 4 — ReelCard Bypass: set `isReelsPageVisible = false`, call `globalResume()` directly, assert `_globalAudioPlayer.state != PlayerState.playing`
  - Run tests on UNFIXED code
  - **EXPECTED OUTCOME**: Tests FAIL (this is correct — it proves the bug exists)
  - Document counterexamples found (e.g., `fetchReels` starts audio with wrong default, unconditional resume starts audio on hidden tab)
  - Mark task complete when tests are written, run, and failures are documented
  - _Requirements: 1.1, 1.2, 1.4, 1.5_

- [ ] 2. Write preservation property tests (BEFORE implementing fix)
  - **Property 2: Preservation** - Audio Behavior Unchanged When Reels Tab Is Active
  - **IMPORTANT**: Follow observation-first methodology
  - Create `test/features/home/presentation/stores/reels_store_preservation_test.dart`
  - Observe: with `isReelsPageVisible = true`, `setCurrentIndex(n)` plays audio for reel[n] and pauses others — record this behavior
  - Observe: with `isReelsPageVisible = true`, `setPageVisibility(false)` stops audio and `setPageVisibility(true)` resumes it — record this behavior
  - Observe: with `isReelsPageVisible = true`, `setFeedType(ReelsFeedType.friends)` stops audio and reloads feed — record this behavior
  - Observe: reel with `audioUrl == null` never triggers audio player calls — record this behavior
  - Write property-based tests using `test` package: for all non-zero reel indices with `isReelsPageVisible = true`, audio plays for focused reel (from Preservation Requirements in design)
  - Write property-based test: for all `isReelsPageVisible = true` background/foreground cycles, audio resumes correctly
  - Write property-based test: for all reels with `audioUrl == null`, no audio player calls are made
  - Run tests on UNFIXED code
  - **EXPECTED OUTCOME**: Tests PASS (this confirms baseline behavior to preserve)
  - Mark task complete when tests are written, run, and passing on unfixed code
  - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5_

- [ ] 3. Fix reels audio tab visibility bug

  - [ ] 3.1 Fix 1 — Correct default value in ReelsStore
    - In `lib/features/home/presentation/stores/reels_store.dart`, change `bool isReelsPageVisible = true` → `bool isReelsPageVisible = false`
    - This prevents `fetchReels` from auto-playing audio before the Reels tab is ever shown
    - The existing guard `if (isReelsPageVisible && currentActiveReelId == null && reels.isNotEmpty)` in `fetchReels` already handles this correctly once the default is `false`
    - _Bug_Condition: isBugCondition(state) where state.isReelsPageVisible == true AND state.isReelsTabActive == false (root cause 1)_
    - _Expected_Behavior: isReelsPageVisible initializes to false; fetchReels does NOT auto-play audio on first load_
    - _Preservation: All audio behavior while isReelsPageVisible == true is unaffected_
    - _Requirements: 2.1_

  - [ ] 3.2 Fix 2 — Remove inner VisibilityDetector from ReelsPage body
    - In `lib/features/home/presentation/pages/reels_page.dart`, remove the `VisibilityDetector` with key `reels_page_vis` that wraps `body:`
    - The `Observer(builder: (_) { ... })` becomes the direct child of `body:` instead
    - The outer `VisibilityDetector` with key `reels_page_container_vis` (wrapping the entire `AppScaffold`) remains as the single authoritative visibility source
    - _Bug_Condition: innerDetectorFiredTrue AND outerDetectorFiredFalse — inner detector (threshold 0.8) overrides outer detector's setPageVisibility(false) during tab-switch animation (root cause 2)_
    - _Expected_Behavior: single authoritative setPageVisibility signal from outer detector only_
    - _Preservation: Observer content (loading/error/empty/PageView states) is unchanged_
    - _Requirements: 2.2_

  - [ ] 3.3 Fix 3 — Guard app lifecycle resume behind `_isPageVisible`
    - In `lib/features/home/presentation/pages/reels_page.dart`, in `didChangeAppLifecycleState`, wrap the `resumed` branch: `if (_isPageVisible) { _store.setPageVisibility(true); _store.globalResume(); }`
    - Note: the current code uses `reelsTabActiveNotifier` / `_handleTabActiveChange` rather than a `_isPageVisible` field — guard the `resumed` branch with the equivalent active-tab check (e.g., `if (reelsTabActiveNotifier.value)`)
    - _Bug_Condition: state.appLifecycleState == resumed AND state.isReelsTabActive == false AND globalResumeCalledUnconditionally (root cause 3)_
    - _Expected_Behavior: app resume only calls setPageVisibility(true) + globalResume() when the Reels tab is actually active_
    - _Preservation: foregrounding while on Reels tab still resumes audio correctly (requirement 3.3)_
    - _Requirements: 2.4, 3.3_

  - [ ] 3.4 Fix 4 — Guard ReelCard globalResume behind `store.isReelsPageVisible`
    - In `lib/features/home/presentation/widgets/reel_card.dart`, in `VisibilityDetector.onVisibilityChanged`, add `&& widget.store.isReelsPageVisible` guard before calling `widget.store.globalResume()`
    - Change: `else if (widget.shouldPlay && widget.reel.isPhoto && widget.reel.audioUrl != null)` → `else if (widget.shouldPlay && widget.reel.isPhoto && widget.reel.audioUrl != null && widget.store.isReelsPageVisible)`
    - _Bug_Condition: state.reelCardVisibleFraction > 0.1 AND state.isReelsPageVisible == false AND globalResumeCalledFromCard (root cause 4)_
    - _Expected_Behavior: ReelCard only calls globalResume() when isReelsPageVisible == true_
    - _Preservation: scrolling between reels while on Reels tab still plays/pauses audio correctly (requirement 3.1)_
    - _Requirements: 2.5, 3.1_

  - [ ] 3.5 Verify bug condition exploration test now passes
    - **Property 1: Expected Behavior** - Audio Stops When Reels Tab Is Hidden
    - **IMPORTANT**: Re-run the SAME tests from task 1 — do NOT write new tests
    - The tests from task 1 encode the expected behavior
    - When these tests pass, it confirms all four root causes are resolved
    - Run `flutter test test/features/home/presentation/stores/reels_store_bug_condition_test.dart`
    - **EXPECTED OUTCOME**: Tests PASS (confirms bug is fixed)
    - _Requirements: 2.1, 2.2, 2.4, 2.5_

  - [ ] 3.6 Verify preservation tests still pass
    - **Property 2: Preservation** - Audio Behavior Unchanged When Reels Tab Is Active
    - **IMPORTANT**: Re-run the SAME tests from task 2 — do NOT write new tests
    - Run `flutter test test/features/home/presentation/stores/reels_store_preservation_test.dart`
    - **EXPECTED OUTCOME**: Tests PASS (confirms no regressions)
    - Confirm scrolling, background/foreground, feed-type switch, and no-audio-url behaviors are all unchanged

- [ ] 4. Checkpoint — Ensure all tests pass
  - Run `flutter test` to confirm all tests pass
  - Run `flutter analyze` to confirm no new static analysis issues
  - Ensure all tests pass; ask the user if questions arise
