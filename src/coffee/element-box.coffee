class DomBox.ElementBox extends DomBox.Box

  constructor: (@element) ->
    super()

  update: ->
    # if element exists and is present in the document, calculate all properties
    if document.body.contains @element

      box_data = @element.getBoundingClientRect()
      viewport_position = DomBox.Viewport.getPosition()

      @width       = box_data.width ? @element.offsetWidth
      @height      = box_data.height ? @element.offsetHeight
      @view_left   = box_data.left
      @view_top    = box_data.top
      @view_right  = box_data.right
      @view_bottom = box_data.bottom

      @left = box_data.left + viewport_position.left
      @top = box_data.top + viewport_position.top
      @right = @left + @width
      @bottom = @top + @height

    # if element does not exist or is not present in the document,
    # set all properties to zero
    else
      properties = [
        'width', 'height'
        'left', 'top', 'right', 'bottom'
        'view_left', 'view_top', 'view_right', 'view_bottom'
      ]
      for property in properties
        @[property] = 0

    super()

  # helper function used to get value of element's CSS property
  getCssProperty: (elm, property) ->

    # modern browsers
    if window.getComputedStyle?
      style = window.getComputedStyle elm, null
      return style.getPropertyValue property

    # old versions of IE
    if elm.currentStyle?
      # convert property name to camelCase
      property = property.replace /-(.)/g, (match, group1) ->
        group1.toUpperCase()
      return elm.currentStyle[property]

    null
