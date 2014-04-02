# HTML5 Video Player

Customized, easily themeable HTML5 video player.

*Note: all aspects are in-progress*

### Development Goals

*Note: delete this section when development is closer to completion*

This player exists mainly as a backup plan in case SublimeVideo, recently bought by DailyMotion, drops support. A modern solution, one without a flash fallback, is the aim of this player. A few benchmarks for development:

* Only `MP4 H.264` and `WebM` are needed as formats (H.264 will account for about 90% support). Between these two formats every modern browser is supported (`OGG` in all instances is equal to WebM support, but WebM still has wider support)
* No flash fallback is needed for any devices, however, **fullscreen** in IE9 & IE10 will need to have some sort of workaround. This is the only forseeable shortfall with avoiding a flash fallback.
* Nearly every modern <video> player takes the approach of dynamically using JS to strip the `controls` parameter and overlay its own HTML controls with JS-bound events. This player is no different.  
* It’s HTML5-compliant, and doesn’t require any non-W3C attributes to work.
  * Uses `poster` to set default pre-start image
  * Pulls `width` and `height` from video element on initialization
  *Note: [ShadowDOM manipulation](http://codepen.io/Volker_E/pen/jsHFC) is currently only supported in Chrome, with no plans for additional support from other browsers any time soon. For that reason this approach is ignored.*

### Initialization
HTML:
```
<video controls height="300" poster="poster.jpg" width="600">
  <source src="mp4.mp4" type="video/mp4">
  <source src="webm.webm" type="video/webm">
</video>
```
JS:

```
<script type="text/javascript">
  env = new EnvyVideo(videoElement[, settings]);
</script>
```
`videoElement` *(required)* can handle:
* CSS selector (will take the first instance)
* JavaScript DOM element object
* jQuery object

`settings` *(optional)* handles a JS object to override default settings
* `prefix` : `string` Class prefix for all CSS hooks *Default: `envy-video`*

### Notes

Some notes exist on Google Drive for now:

https://drive.google.com/#folders/0B0V3MqSa3ulNUmdJZ1ZfQnVxTFE


### Todo

Required development

1. Make the scrubber work
2. Add fullscreen (for IE9 + IE10, position:fixed & stretch, maybe?)
3. Add quality toggle (lo, hi quality similar to Vimeo—maybe no more than that)
4. Add playback speed (I was thinking 1x, 1.1x, 1.3x, 1.6x, and 2x; reasoning is +10%, +20%, +40% relative to each other. Plus it’s a slimmer button than three-digit 1.25x, etc.)
5. Add subtitle functionality (.vtt files; see http://docs.sublimevideo.net/subtitles)
6. Add shortcuts (space to play, etc.)
  1. Make sure competiting shortcuts don’t fire on top of each other or are janky in general (refer to “[Throttling](http://underscorejs.org/#throttle)” function from Underscore.js)
  2. Events should ideally be on “keydown” rather than “keyup” but should probably only fire once until keyup.
7. Buffering and loading control
8. The API, complete with action methods and status queries

### Wishlist

Nice stuff to have

1. Add scrubber thumbnails on playhead hover like on YouTube (maybe create a `<canvas>` element offscreen and write current seek point to that canvas—maybe. Read: http://www.html5rocks.com/en/tutorials/canvas/performance/)
2. Playlists
  1. Prev / Next videos
3. Audio language switch (multiple audio tracks)

### API

*Some ideas for API calls; ones in __bold__ exist now. All others are conceptual at this point and may change*

#### Methods: Commands
* **`destroy`** Teardown and unbind all event listeners
* `fullscreen`
* `next` Go to next video in playlist and play
* **`pause`** Pause playback
* **`play`**  Start/resume playback
* **`playPause` ** Toggle between play and pause
* `prev` Go to previous video in playlist
* `seek(ms)` Jump to point in video  
  `@param num` Milliseconds to jump to
* `setAudio(audioFileMP4, audioFileWebM [, muteVideo])` Change the audio track on the video (useful for language dubs)  
  `@param str` Path to MP4 audio file  
  `@param str` Path to WebM audio file  
  `@param bool` Mute the video’s embedded audio track? *Default: true*
* **`setHeight(num)`**
* `setVideo(videoFileMP4, videoFileWebM)` Change video files and restart video without destructing player  
  `@param str` Path to MP4 video file  
  `@param str` Path to WebM audio file  
  *Note: when this is actually implemented, maybe an option to change the poster image?*
* **`setWidth(num)`**
* `sub(on[, vtt])` Turn subtitles on/off and/or set/change subtitle file
  `@param bool` Subtitles visible? True or false  
  `@param str` Path to *.vtt subtitle file
* `update(settings, callback)`  
 ` @param obj` Settings to change; reinitializes

#### Methods: Events
* `beforeReady(callback)`
* `onNext(callback)`
* `onPause(callback)`
* `onPlay(callback)`
* `onPrev(callback)`
* `onReady(callback)`
* `onSetupError(callback)`

#### Methods: Boolean Retrievals
* `isBuffering` & `isLoaded`
* `isFullscreen`
* **`isPlaying`**
* **`isPaused`**
* `isReady`

#### Methods: Other Retrievals
* `getVideo`
* `getPlaylist`  
  `@returns Array` of objects

### References

* [Apple AirPlay](https://developer.apple.com/library/ios/documentation/AudioVideo/Conceptual/AirPlayGuide/OptingInorOutofAirPlay/OptingInorOutofAirPlay.html)
* [Chromecast](https://developers.google.com/cast/chrome_sender)
* [H.264 Now Open-Source (Oct 30, 2013)](https://blog.mozilla.org/blog/2013/10/30/video-interoperability-on-the-web-gets-a-boost-from-ciscos-h-264-codec/)
* __[HTML5 `canvas` Performance](http://www.html5rocks.com/en/tutorials/canvas/performance/)__
* [HTML5 `video` Support](http://html5test.com/compare/browser/index.html)
* [Moz `video` Support](https://developer.mozilla.org/en-US/docs/HTML/Supported_media_formats)
* [Safari `video` Support](https://developer.apple.com/library/safari/documentation/AudioVideo/Conceptual/Using_HTML5_Audio_Video/AudioandVideoTagBasics/AudioandVideoTagBasics.html)
* [Sublime Subtitle API](http://docs.sublimevideo.net/subtitles)
* [VTT Specification](http://dev.w3.org/html5/webvtt/)