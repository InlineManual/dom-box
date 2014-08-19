# conversion between radians and degrees
radToDeg = (angle) -> angle * (180 / Math.PI)
degToRad = (angle) -> angle * (Math.PI / 180)

# convert input angle so that it is always positive number within 0 to 360
normalizeAngle = (angle) ->
  angle = angle % 360
  angle += 360 if angle < 0
  angle
