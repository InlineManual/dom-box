DomBox.Viewport =

  getWidth: ->
    Math.max(
      document.documentElement.clientWidth
      window.innerWidth or 0
    )

  getHeight: ->
    Math.max(
      document.documentElement.clientHeight
      window.innerHeight or 0
    )

  getSize: ->
    {
      width: DomBox.Viewport.getWidth()
      height: DomBox.Viewport.getHeight()
    }

  getLeft: ->
    (window.pageXOffset or document.documentElement.scrollLeft) -
    (document.documentElement.clientLeft or 0)

  getTop: ->
    (window.pageYOffset or document.documentElement.scrollTop) -
    (document.documentElement.clientTop or 0)

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

  # Adjusts position of box so that it is contained within viewport. If the box
  # can not fit, its top-left corner matches viewports top-left corner. If the
  # box is within viewport, its position does not change.
  moveInside: (box) ->
    box = DomBox.getBox box
    viewport = DomBox.Viewport.getBox()
    position = {left: null, top: null}

    if box.right > viewport.right
      position.left = viewport.right - box.width
    if box.bottom > viewport.bottom
      position.top = viewport.bottom - box.height
    if box.left < viewport.left
      position.left = viewport.left
    if box.top < viewport.top
      position.top = viewport.top

    box.moveTo position.left, position.top

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
      viewport.left < box.right <= viewport.right
    ) and
    (
      viewport.top <= box.top < viewport.bottom or
      viewport.top < box.bottom <= viewport.bottom
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

  # Adjusts position of box2 so that it is fully in viewport and does not
  # colide with box1.
  fitAround: (box1, box2) ->
    box1 = DomBox.getBox box1
    box2 = DomBox.getBox box2

    if DomBox.Viewport.canFitAround box1, box2
      gaps = DomBox.Viewport.getGaps box1

      DomBox.Viewport.moveInside box2

      return unless DomBox.detectOverlap box1, box2
      if box2.width <= gaps.horizontal.before
        box2.moveTo (box1.left - box2.width), null

      return unless DomBox.detectOverlap box1, box2
      if box2.height <= gaps.vertical.before
        box2.moveTo null, (box1.top - box2.height)

      return unless DomBox.detectOverlap box1, box2
      if box2.width <= gaps.horizontal.after
        box2.moveTo box1.right, null

      return unless DomBox.detectOverlap box1, box2
      if box2.height <= gaps.vertical.after
        box2.moveTo null, box1.bottom


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

  # very handy for debuging
  toString: -> JSON.stringify DomBox.Viewport.getBox()
