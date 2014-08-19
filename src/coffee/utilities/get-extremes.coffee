getExtremes = (boxes = []) ->
  result = {}

  min_properties = ['left', 'top', 'view_left', 'view_top']
  max_properties = ['right', 'bottom', 'view_right', 'view_bottom']
  all_properties = [].concat min_properties, max_properties

  # first gather list of values of all properties from boxes...
  data = {}
  for key in all_properties
    data[key] = []
    data[key].push box[key] for box in boxes

  # ...then find their minimal and maximal values
  for property in min_properties
    result[property] = Math.min.apply null, data[property]
  for property in max_properties
    result[property] = Math.max.apply null, data[property]

  # calculate new size
  result.width = result.right - result.left
  result.height = result.bottom - result.top

  result
