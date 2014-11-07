# external dependency check
throw new Error 'Popover requires AngleJS library to operate.' unless Angle?


DomBox =

  angle: new Angle

  getBox: (input) ->
    return new @CollectionBox input if typeof input is 'string'
    return new @ElementBox input if isElement input
    return input if input instanceof DomBox.Box
    null

  getDistance: (box1, box2) ->
    box1 = DomBox.getBox box1
    box2 = DomBox.getBox box2
    bounding_box = getExtremes [box1, box2]

    result =
      horizontal: bounding_box.width - (box1.width + box2.width)
      vertical: bounding_box.height - (box1.height + box2.height)

    # convert negative distance to zerov (this means boxes are overlaping)
    result.horizontal = 0 if result.horizontal < 0
    result.vertical = 0 if result.vertical < 0

    result

  detectOverlap: (box1, box2) ->
    box1 = DomBox.getBox box1
    box2 = DomBox.getBox box2
    bounding_box = getExtremes [box1, box2]

    overlap =
      horizontal: bounding_box.width - (box1.width + box2.width)
      vertical: bounding_box.height - (box1.height + box2.height)

    # Boxes are overlaping when both horizontal and vertical distance between
    # them is negative.
    overlap.horizontal < 0 and overlap.vertical < 0

  getPivotDistance: (box1, box2) ->
    box1 = DomBox.getBox box1
    box2 = DomBox.getBox box2

    pivot1 = box1.getPivot()
    pivot2 = box2.getPivot()

    x = pivot1.left - pivot2.left
    y = pivot1.top - pivot2.top

    # Pythagoras
    Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2))

  getPivotAngle: (box1, box2) ->
    box1 = DomBox.getBox box1
    box2 = DomBox.getBox box2

    pivot1 = box1.getPivot()
    pivot2 = box2.getPivot()

    angle_rad = Math.atan2(pivot2.top - pivot1.top, pivot2.left - pivot1.left)
    angle_deg = DomBox.angle.fromRad angle_rad
    DomBox.angle.normalize angle_deg

# Expose object to the global namespace.
root = if typeof exports is 'object' then exports else this
root.DomBox = DomBox
