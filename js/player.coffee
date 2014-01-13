class @EnvyVideo

# I. Initialization
  _video: `undefined`
  _wrap: `undefined`

  _defaults: {
    'debug' : false
    'prefix' : 'envy-video'
  }

  status: {
    'hasControls' : false
    'hasStarted' : false
    'isPlaying' : false
  }

  constructor: (@options) -> @init()

  destroy: ->
    if @status.hasControls is true
      @_video.setAttribute 'controls', ''
    @_video.removeAttribute 'data-action'
    @_video.parentNode.removeChild @_video
    @_wrap.parentNode.insertBefore @_video, @_wrap
    @_wrap.parentNode.removeChild @_wrap
    @_video = `undefined`
    @_wrap = `undefined`
    @status = {
      'hasControls' : false
      'hasStarted' : false
      'isPlaying' : false
    }

  init: ->
    @options = EnvyVideo.merge {}, @_defaults, @options

    errors =
      'initFail' : "EnvyVideo failed: could not find a <video> element matching `" + @options.video + "`."
      'initMissing' : "Please select a <video> element to style by setting EnvyVideo({ 'video' : videoElementOrSelector })."
      'units' : "You specified a unit measurement. Please omit units such as px and em."

    ctrls =
      'next' : {}
      'playPause' : {}
      'speed' : {}
      'quality' : {}

    unless @options.video is `undefined`

    # 1. Find <video>
      switch typeof @options.video
        when 'array', 'object'
      # 1b. DOM object
          if @options.video.nodeName is 'VIDEO'
            @_video = @options.video

      # 1c. jQuery object / querySelectorAll array
          else
            if @options.video[0].nodeName is 'VIDEO'
              @_video = @options.video[0]
            else EnvyVideo.throwError errors.initFail # Oops not a <video> element

      # 1d. Selector query
        when 'string'
          sel = document.querySelector(@options.video)
          if sel
            @_video = sel
          else EnvyVideo.throwError errors.initFail
        else EnvyVideo.throwError errors.initFail

    # 2. Wrap
      @_wrap = document.createElement 'div'
      @_wrap.className = @options.prefix + '--wrap'
      @_video.parentNode.insertBefore @_wrap, @_video
      @_video.parentNode.removeChild @_video
      @_wrap.appendChild @_video
      @setWidth @_video.width
      @setHeight @_video.height

      img = @_video.getAttribute 'poster'
      if img
        poster = document.createElement 'div'
        poster.className = @options.prefix + '--poster'
        poster.style.backgroundImage = 'url(' + img + ')'
        poster.setAttribute 'data-action', 'play'
        poster.addEventListener 'click', ((e) => @bind e), true
        poster.innerHTML = '<div class="' + @options.prefix + '--overlay"></div>'
        @_wrap.appendChild poster

    # 3. Add Controls
      unless @_video.getAttribute('controls') is `null`
        @_video.removeAttribute 'controls'
        @status.hasControls = true
      @_video.setAttribute 'data-action', 'playPause'
      @_video.addEventListener 'click', ((e) => @bind e), true
      ctrl = document.createElement 'div'
      ctrl.className = @options.prefix + '--ctrl'
      @_wrap.appendChild ctrl

      actions = [
        'type': 'playPause'
        'container': 'button'
        'className': @options.prefix + '--btn ' + @options.prefix + '--playPause'
        'innerHTML': '<i class="' + @options.prefix + '--icn ' + @options.prefix + '--icn--playPause"></i>'
      ,
        'type': 'scrub'
        'container': 'div'
        'className': @options.prefix + '--scrub'
        'innerHTML': '<div class="' + @options.prefix + '--timeline"></div><div class="' + @options.prefix + '--progress"></div><div class="' + @options.prefix + '--playhead"></div>'
      ,
        'type': 'quality'
        'container': 'button'
        'className': @options.prefix + '--btn ' + @options.prefix + '--quality'
        'innerHTML': '<i class="' + @options.prefix + '--icn ' + @options.prefix + '--icn--quality"></i>'
      ,
        'type' : 'fs'
        'container' : 'button'
        'className': @options.prefix + '--btn ' + @options.prefix + '--fs'
        'innerHTML' : '<i class="' + @options.prefix + '--icn ' + @options.prefix + '--icn--fs"></i>'
      ]
      for action in actions
        btn = document.createElement action.container
        btn.className = action.className
        btn.setAttribute 'data-action', action.type
        btn.innerHTML = action.innerHTML
        btn.addEventListener 'click', ((e) => @bind e), true
        ctrl.appendChild btn

    # 4. Add bindings
        EnvyVideo.bind action, btn

    # 5. Set up scrubber
      progress = document.querySelector '.' + @options.prefix + '--progress'
      playhead = document.querySelector '.' + @options.prefix + '--playhead'
      
      @_video.addEventListener 'timeupdate', (e) =>
        pct = ((e.srcElement.currentTime / e.srcElement.duration) * 100).toFixed(2)
        progress.style.width = pct + '%'
        playhead.style.left = pct + '%'

    # 6. Shortcut Keys
      document.onkeydown = (e) =>
        switch e.keyCode
          when 32
            @playPause()
            e.preventDefault()

    else
      EnvyVideo.throwError errors.initMissing # Oops @options.video not set

# II. Public Actions

  setHeight: (h) ->
    @_wrap.style.height = h + 'px'
    @_video.setAttribute 'height', h

  setWidth: (w) ->
    @_wrap.style.width = w + 'px'
    @_video.setAttribute 'width', w

  pause: ->
    document.title = document.title.replace '▸ ', ''
    @status.isPlaying = false
    @_video.pause()
    @removeClass @_wrap, 'is--playing'

  play: ->
    @status.isPlaying = true
    @_video.play()
    @addClass @_wrap, 'is--playing'
    document.title = '▸ ' + document.title
    unless @status.hasStarted
      @status.hasStarted = true
      @addClass @_wrap, 'has--started'

  playPause: ->
    unless @status.isPlaying
      @play()
    else
      @pause()

# III. Public Events
  
  beforeReady: (callback) ->
    callback? callback

  onPause: (callback) ->
    callback? callback

  onPlay: (callback) ->
    callback? callback

  onReady: (callback) ->
    callback? callback

# IV. Public Status Methods

  isPaused: ->
    !@status.isPlaying

  isPlaying: ->
    @status.isPlaying

  hasStarted: =>
    @status.hasStarted

# V. Private Helpers
  addClass: (el, addThis) ->
    current = el.className
    if current.indexOf(' ' + addThis) is -1
      el.className = current + ' ' + addThis
  
  bind: (event) ->
    if typeof event is 'object'
      # Check for data-action attribute on target or try parent (if icon in button is clicked)
      action = if event.target.getAttribute 'data-action' then event.target.getAttribute 'data-action' else event.target.parentNode.getAttribute 'data-action'
      switch action
        when 'play' then @play()
        when 'playPause' then @playPause()

  @merge = (target, extensions...) ->
    for extension in extensions
      for own property of extension
        target[property] = extension[property]
    target

  removeClass: (el, removeThis) ->
    current = el.className
    unless current.indexOf(' ' + removeThis) is -1
      current = ' ' + current.replace(' ' + removeThis, '')
      el.className = current.replace(/^\s\s*/, '').replace(/\s\s*$/, '')

  @setOptions: (options) ->
    @options = merge {}, @defaults, options
    this

  @throwError: (msg) ->
    console.log msg
    false

    

