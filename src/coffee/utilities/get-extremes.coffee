getExtremes = (boxes = []) ->
  result = {}

  data =
    width: []
    height: []
    left: []
    top: []
    right: []
    bottom: []
    view_left: []
    view_top: []
    view_right: []
    view_bottom: []

  for box in boxes
    for key, val of data
      data[key].push box[key]

  for property in ['left', 'top', 'view_left', 'view_top']
    result[property] = Math.min.apply null, data[property]
  for property in ['right', 'bottom', 'view_right', 'view_bottom']
    result[property] = Math.max.apply null, data[property]

  result.width = result.right - result.left
  result.height = result.bottom - result.top

  result
