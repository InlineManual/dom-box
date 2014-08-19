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

  getLeft: ->
    (window.pageXOffset or html.scrollLeft) - (html.clientLeft or 0)

  getTop: ->
    (window.pageYOffset or html.scrollTop) - (html.clientTop or 0)

  getPosition: ->
    {
      left: DomBox.Viewport.getLeft()
      top: DomBox.Viewport.getTop()
    }

  getBox: ->
    position = DomBox.Viewport.getPosition()
    size = DomBox.Viewport.getSize()
    {
      width: size.width
      height: size.height
      left: position.left
      top: position.top
      right: position.left + size.width
      bottom: position.top + size.height
    }

  contains: (box) ->
    box = DomBox.getBox box
    return false unless box?
    viewport = @getBox()

    viewport.left <= box.left and
    viewport.top <= box.top and
    viewport.right >= box.right and
    viewport.bottom >= box.bottom

  partialyContains: (box) ->
    box = DomBox.getBox box
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
    box = DomBox.getBox box
    return false unless box?

    box.width <= @getWidth() and
    box.height <= @getHeight()

  canCoexist: (box1, box2) ->
    box1 = DomBox.getBox box1
    box2 = DomBox.getBox box2
    return false unless box1? and box2?

    bounding_box = getExtremes [box1, box2]

    bounding_box.width <= @getWidth() and
    bounding_box.height <= @getHeight()
