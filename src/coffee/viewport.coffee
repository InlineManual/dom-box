DomBox.Viewport =

  getWidth: ->
    Math.max(
      html.clientWidth
      window.innerWidth or 0
    )

  getHeight: ->
    Math.max(
      html.clientHeight
      window.innerHeight or 0
    )

  getSize: ->
    {
      width: DomBox.Viewport.getWidth()
      height: DomBox.Viewport.getHeight()
    }

  getBox: ->
    scroll = DomBox.Scroll.getPosition()
    size = DomBox.Viewport.getSize()
    {
      width: size.width
      height: size.height
      left: scroll.left
      top: scroll.top
      right: scroll.left + size.width
      bottom: scroll.top + size.height
    }

  contains: (box) ->
    return false unless box?
    viewport = @getBox()

    viewport.left <= box.left and
    viewport.top <= box.top and
    viewport.right >= box.right and
    viewport.bottom >= box.bottom

  partialyContains: (box) ->
    return false unless box?
    viewport = @getBox()

    (
      viewport.left <= box.left < viewport.right or
      viewport.left > box.right >= viewport.right
    ) and
    (
      viewport.top <= box.top < viewport.bottom or
      viewport.top > box.bottom >= viewport.bottom
    )

  canContain: (box) ->
    return false unless box?

    box.width <= @getWidth() and
    box.height <= @getHeight()

  canCoexist: (box1, box2) ->
    return false unless box1? and box2?

    bounding_box = getExtremes [box1, box2]

    bounding_box.width <= @getWidth() and
    bounding_box.height <= @getHeight()
