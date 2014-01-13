# CS HTML5 Video Player

Customized, easily themeable HTML5 video player.

*Note: all aspects are in-progress*

### Development Goals

*Note: delete this section when development is closer to completion*

This player exists mainly as a backup plan in case SublimeVideo, recently bought by DailyMotion, drops support. A modern solution, one without a flash fallback, is the aim of this player. A few benchmarks for development:

* Currently, only `MP4 H.264` and `WebM` are needed as formats (MP4 will account for about 90% support). Between these two formats every modern browser is supported (`OGG` in all instances is equal to WebM support, but WebM still has wider support)
* No flash fallback is needed for any devices, however, **fullscreen** in IE9 & IE10 will need to have some sort of workaround. This is the only forseeable shortfall with avoiding a flash fallback.
* Nearly every modern <video> player takes the approach of dynamically using JS to strip the `controls` parameter and overlay its own HTML controls with JS-bound events. This player is no different.  
  *Note: [ShadowDOM manipulation](http://codepen.io/Volker_E/pen/jsHFC) is currently only supported in Chrome, with no plans for additional support from other browsers any time soon. For that reason this approach is ignored.*

### Initialization

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

1. Add scrubber thumbnails on playhead hover like on YouTube (maybe create a <canvas> element offscreen and write current seek point to canvas—maybe. Read: http://www.html5rocks.com/en/tutorials/canvas/performance/)
2. Playlists
  1. Prev / Next videos
3. Audio language switch (multiple audio tracks)

### API

*Some ideas for API calls; ones in __bold__ exist now. All others are conceptual at this point and may change*

#### Methods: Commands
* **`destroy`** Teardown and unbind all event listeners
* `fullscreen`
* `load`
* `next` For playlists
* **`pause`**
* **`play`**
* `prev` Also for playlists
* `seek(ms)`
  `@param num` Milliseconds to jump to
* **`setHeight(num)`**
* **`setWidth(num)`**
* `sub(on[, vtt])`  
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
