# Bugfix Requirements Document

## Introduction

Audio from the Reels page continues playing (or resumes incorrectly) when the user switches to a different tab via the app's bottom navigation. The root causes span multiple layers: `isReelsPageVisible` defaults to `true` in `ReelsStore` before the page is ever shown, two competing `VisibilityDetector` instances both call `setPageVisibility` and can conflict, `didChangeAppLifecycleState` resumes audio without checking whether the Reels tab is actually active, and `ReelCard`'s own `VisibilityDetector` calls `globalResume()` independently — bypassing the page-level guard. Because `AutomaticKeepAliveClientMixin` keeps the widget alive across tab switches, `dispose()` never fires, so the `stopAudio()` call there is never reached.

## Bug Analysis

### Current Behavior (Defect)

1.1 WHEN the app launches and the Reels tab has never been opened THEN the system treats the Reels page as visible (`isReelsPageVisible = true`) and may start playing audio before the page is actually shown

1.2 WHEN the user switches from the Reels tab to any other bottom-navigation tab THEN the system continues playing audio because the `VisibilityDetector` with key `reels_page_vis` (threshold > 0.8) fires a conflicting `setPageVisibility(true)` call that overrides the outer detector's `setPageVisibility(false)`

1.3 WHEN the user switches from the Reels tab to any other bottom-navigation tab THEN the system does not stop audio via `dispose()` because `AutomaticKeepAliveClientMixin` keeps the widget alive and `dispose()` is never called

1.4 WHEN the app resumes from background while a non-Reels tab is active THEN the system calls `globalResume()` unconditionally, causing audio to play even though the Reels tab is not visible

1.5 WHEN a `ReelCard` becomes visible in the viewport while the Reels tab is hidden THEN the system calls `globalResume()` from the card's own `VisibilityDetector`, bypassing the page-level visibility guard and leaking audio to other tabs

### Expected Behavior (Correct)

2.1 WHEN the app launches and the Reels tab has never been opened THEN the system SHALL initialize `isReelsPageVisible` to `false` and only set it to `true` once the Reels tab is confirmed visible

2.2 WHEN the user switches from the Reels tab to any other bottom-navigation tab THEN the system SHALL immediately stop audio and set `isReelsPageVisible` to `false`, with a single authoritative visibility signal (the outer `VisibilityDetector` with key `reels_page_container_vis`) driving `setPageVisibility`

2.3 WHEN the user switches back to the Reels tab THEN the system SHALL resume audio for the currently focused reel and set `isReelsPageVisible` to `true`

2.4 WHEN the app resumes from background THEN the system SHALL only resume audio if `isReelsPageVisible` is already `true` at the time of resumption

2.5 WHEN a `ReelCard`'s `VisibilityDetector` fires a resume event THEN the system SHALL only call `globalResume()` if `isReelsPageVisible` is `true`, preventing audio leaks when the page is hidden

### Unchanged Behavior (Regression Prevention)

3.1 WHEN the user is on the Reels tab and scrolls between reels THEN the system SHALL CONTINUE TO play audio for the currently focused reel and pause audio for reels that scroll out of view

3.2 WHEN the user is on the Reels tab and the app is sent to the background THEN the system SHALL CONTINUE TO pause audio on `AppLifecycleState.paused` / `inactive`

3.3 WHEN the user is on the Reels tab and the app returns to the foreground THEN the system SHALL CONTINUE TO resume audio for the currently focused reel

3.4 WHEN the user switches between the "Bạn bè" and "Khám phá" feed tabs within the Reels page THEN the system SHALL CONTINUE TO stop audio and reload the feed correctly

3.5 WHEN a reel has no audio URL THEN the system SHALL CONTINUE TO play the video without audio and not attempt to start the audio player
