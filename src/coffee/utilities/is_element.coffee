# Utility function that returns true if referenced object is DOM element.
# NOTE: Simply checking if obj is instance of HTMLElement would not work here,
# because that would exclude exotic elements like SVG polygons, etc.
isElement = (obj) ->
  obj?                                  and
  typeof obj is 'object'                and
  obj.nodeType is 1                     and
  typeof obj.style is 'object'          and
  typeof obj.ownerDocument is 'object'
