class DomBox.Box

  _properties: [
      'width', 'height'
      'left', 'top', 'right', 'bottom'
      'view_left', 'view_top', 'view_right', 'view_bottom'
    ]

  constructor: ->
    # set default values
    @[property] = 0 for property in @_properties
    @padding = 0
    @update()

  update: ->
    @pad @padding

  setPadding: (@padding) ->
    @update()

  pad: (padding = 0) ->
    @width       += (padding * 2)
    @height      += (padding * 2)
    @left        -= padding
    @top         -= padding
    @right       += padding
    @bottom      += padding
    @view_left   -= padding
    @view_top    -= padding
    @view_right  += padding
    @view_bottom += padding

  getPivot: ->
    {
      left: @left + (@width / 2)
      top: @top + (@height / 2)
    }

  # this makes debuging so much easier
  toString: ->
    result = {}
    result[property] = @[property] for property in @_properties
    JSON.stringify result
