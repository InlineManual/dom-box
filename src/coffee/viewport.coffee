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

  # Returns true if both boxes can fit together into the viewport.
  # This only considers dimensions of boxes, not their positions.
  canCoexist: (box1, box2) ->
    box1 = DomBox.getBox box1
    box2 = DomBox.getBox box2
    return false unless box1? and box2?

    bounding_box = getExtremes [box1, box2]

    bounding_box.width <= @getWidth() and
    bounding_box.height <= @getHeight()

  # Returns true if box2 can fit into the viewport without coliding with box1.
  # This considers position of box1 within viewport.
  canFitAround: (box1, box2) ->
    box1 = DomBox.getBox box1
    box2 = DomBox.getBox box2
    return false unless box1? and box2?

    viewport = DomBox.Viewport.getBox()

    # can box2 itself fit the viewport?
    if box2.width > viewport.width or box2.height > viewport.height
      return false

    # If box2 can fit into either of these gaps, return true
    gaps = DomBox.Viewport.getGaps box1

    # return value
    box2.width <= gaps.horizontal.before or
    box2.width <= gaps.horizontal.after or
    box2.height <= gaps.vertical.before or
    box2.height <= gaps.vertical.after

  # Returns horizontal and vertical sizes of gaps around the box.
  getGaps: (box) ->
    box = DomBox.getBox box
    viewport = DomBox.Viewport.getBox()
    {
      horizontal:
        before: Math.max 0, box.left - viewport.left
        after: Math.max 0, viewport.right - box.right
      vertical:
        before: Math.max 0, box.top - viewport.top
        after: Math.max 0, viewport.bottom - box.bottom
    }
