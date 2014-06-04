# quick reference to frequently used objects
body = document.body
html = document.documentElement

box_properties = [
  'width', 'height'
  'left', 'top', 'right', 'bottom'
  'view_left', 'view_top', 'view_right', 'view_bottom'
]

# Utility function that returns true if referenced object is DOM element.
isElement = (obj) ->
  try
    # modern browsers
    obj instanceof HTMLElement
  catch
    # ancient browsers
    typeof obj is 'object' and
    obj.nodeType is 1 and
    typeof obj.style is 'object' and
    typeof obj.ownerDocument is 'object'

# Returns object containing all box properties calculated so that they fit the
# extreme values of bounding box. This means it takes lowest value for top/left,
# highest value for other coordinates and correctly calculates total
# width/height.
getExtremes = (items = []) ->
  data = {}
  for item in items
    for key in box_properties
      data[key] = [] unless data[key]
      data[key].push item[key]

  result = {}
  for key, val of data
    switch key
      when 'left', 'top', 'view_left', 'view_top'
        result[key] = Math.min.apply null, data[key]
      when 'right', 'bottom', 'view_right', 'view_bottom'
        result[key] = Math.max.apply null, data[key]

  result.width = result.right - result.left
  result.height = result.bottom - result.top

  result

class Box

  default_values:
    width: 0
    height: 0
    left: 0
    top: 0
    right: 0
    bottom: 0
    view_left: 0
    view_top: 0
    view_right: 0
    view_bottom: 0

  constructor: (box) ->
    @box = box
    @update @box

  update: ->
    for key, val of @getData @box
      @[key] = val

  getData: (box) ->
    if box?

      if typeof box is 'string'
        collection = document.querySelectorAll box
        items = (@getElementData element for element in collection)
        items.push @default_values if items.length is 0
        return getExtremes items

      if isElement box
        return @getElementData box

    return @default_values

  getElementData: (element) ->
    box_data = @getBox element
    document_position = @getDocumentPosition element
    {
      width: box_data.width
      height: box_data.height
      left: document_position.left
      top: document_position.top
      right: document_position.left + box_data.width
      bottom: document_position.top + box_data.height
      view_left: box_data.left
      view_top: box_data.top
      view_right: box_data.left + box_data.width
      view_bottom: box_data.top + box_data.height
    }

  # Returns clientRect object for element, which contains most of the data we
  # will need. The top and left position is relative to the viewport.
  getBox: (element) ->
    element.getBoundingClientRect()

  # returns top and left position relative to document
  getDocumentPosition: (element) ->
    position =
      left: 0
      top: 0
    while element
      position.left += element.offsetLeft
      position.top += element.offsetTop
      element = element.offsetParent
    position

  getPivot: ->
    {
      left: @left + (@width / 2)
      top: @top + (@height / 2)
    }

  pad: (padding = 0) ->
    {
      width: @width + (padding * 2)
      height: @height + (padding * 2)
      left: @left - padding
      top: @top - padding
      right: @right + padding
      bottom: @bottom + padding
      view_left: @view_left - padding
      view_top: @view_top - padding
      view_right: @view_right + padding
      view_bottom: @view_bottom + padding
    }

  # returns true if box is completly visible within viewport
  isInViewport: ->
    @update()
    for attribute in ['view_left', 'view_top', 'view_right', 'view_bottom']
      return false if @[attribute] < 0
    return true

  # returns true if box is at least partialy visible within viewport
  isPartialyInViewport: ->
    @update()
    for attribute in ['view_left', 'view_top', 'view_right', 'view_bottom']
      return true if @[attribute] > 0
    return false

  canFitViewport: ->
    @update()
    @width <= DomBox.viewport.getWidth() and
    @height <= DomBox.viewport.getHeight()

DomBox =

  Box: Box

  # Returns correct Box object based on input.
  sanitizeBox: (box) ->
    switch typeof box
      when 'string'
  # If input is string, it is used as CSS selector. Resulting Box represents
  # bounding box of all elements that match the selector.
        new Box box
      when 'object'
        if isElement box
  # If input is reference to DOM element, it returns bounding box of element.
          new Box box
        else
  # If input is reference to existing Box object, it returns it unchanged.
          box
      else
  # If everything else fails, it returns empty Box element (you can add
  # elements to it later).
        new Box()

  # Returns size of vertical and horizontal gap between two boxes. If the boxes
  # overlap, the distance is negative.
  getDistance: (box1, box2) ->
    box1 = @sanitizeBox box1
    box2 = @sanitizeBox box2
    bounding_box = getExtremes [box1, box2]
    {
      horizontal: bounding_box.width - (box1.width + box2.width)
      vertical: bounding_box.height - (box1.height + box2.height)
    }

  # If the distance between two boxes is negative in both directions, they
  # overlap.
  detectOverlap: (box1, box2) ->
    distance = @getDistance box1, box2
    distance.horizontal < 0 and distance.vertical < 0

  getPivotDistance: (box1, box2) ->
    box1 = @sanitizeBox box1
    box2 = @sanitizeBox box2
    pivot1 = box1.getPivot()
    pivot2 = box2.getPivot()

    x = pivot1.left - pivot2.left
    y = pivot1.top - pivot2.top

    # Pythagoras
    Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2))

  getPivotAngle: (box1, box2) ->
    box1 = @sanitizeBox box1
    box2 = @sanitizeBox box2
    pivot1 = box1.getPivot()
    pivot2 = box2.getPivot()

    angle_rad = Math.atan2(pivot2.top - pivot1.top, pivot2.left - pivot1.left)
    angle_deg = angle_rad * 180 / Math.PI
    angle_deg += 360 if angle_deg < 0
    angle_deg

  getRelativeDirection: (box1, box2) ->
    angle = @getPivotAngle box1, box2
    switch
      when angle > 337.5 then 'right'
      when angle > 292.5 then 'top right'
      when angle > 247.5 then 'top'
      when angle > 202.5 then 'top left'
      when angle > 157.5 then 'left'
      when angle > 112.5 then 'bottom left'
      when angle > 67.5 then 'bottom'
      when angle > 22.5 then 'bottom right'
      else 'right'

  # Returns true if both boxes can fit viewport without overlap.
  # Third parameter determines, whether we will allow the viewport to scroll
  # horizontaly. This is the default scenario.
  canCoexist: (box1, box2, lock_horizontal_scroll = true) ->
    box1 = @sanitizeBox box1
    box2 = @sanitizeBox box2

    viewport_width = @viewport.getWidth()
    viewport_height = @viewport.getHeight()

    gap_horizontal = viewport_width - box1.width
    gap_vertical = viewport_height - box1.height

    if lock_horizontal_scroll
      gap_left = box1.left
      gap_right = viewport_width - box1.right
      gap_horizontal = Math.max gap_left, gap_right

    box2.width <= gap_horizontal and box2.height <= gap_vertical

  # DOCUMENT SIZE

  document:

    getWidth: ->
      Math.max(
        body.scrollWidth
        body.offsetWidth
        html.clientWidth
        html.scrollWidth
        html.offsetWidth
      )

    getHeight: ->
      Math.max(
        body.scrollHeight
        body.offsetHeight
        html.clientHeight
        html.scrollHeight
        html.offsetHeight
      )

    getSize: ->
      {
        width: DomBox.document.getWidth()
        height: DomBox.document.getHeight()
      }

  # SCROLL POSITION

  scroll:

    getLeft: ->
      (window.pageXOffset or html.scrollLeft) - (html.clientLeft or 0)

    getTop: ->
      (window.pageYOffset or html.scrollTop) - (html.clientTop or 0)

    getPosition: ->
      {
        left: DomBox.scroll.getLeft()
        top: DomBox.scroll.getTop()
      }

  # VIEWPORT

  viewport:

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
        width: DomBox.viewport.getWidth()
        height: DomBox.viewport.getHeight()
      }

    getBox: ->
      scroll = DomBox.scroll.getPosition()
      size = DomBox.viewport.getSize()
      {
        width: size.width
        height: size.height
        left: scroll.left
        top: scroll.top
        right: scroll.left + size.width
        bottom: scroll.top + size.height
      }

# Expose object to the global namespace.
root = if typeof exports is 'object' then exports else this
root.DomBox = DomBox
