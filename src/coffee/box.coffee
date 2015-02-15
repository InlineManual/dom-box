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

  moveTo: (left = @left, top = @top) ->
    unless isNaN left
      diff_horizontal = @left - left
      @left        = left
      @right       = @left + @width
      @view_left   -= diff_horizontal
      @view_right  -= diff_horizontal

    unless isNaN top
      diff_vertical = @top - top
      @top         = top
      @bottom      = @top + @height
      @view_top    -= diff_vertical
      @view_bottom -= diff_vertical

  moveBy: (left = 0, top = 0) ->
    unless isNaN left
      @left        = @left + left
      @right       = @left + @width
      @view_left   = @view_left + left
      @view_right  = @view_right + left

    unless isNaN top
      @top         += top
      @bottom      = @top + @height
      @view_top    += top
      @view_bottom += top

  resizeTo: (width = @width, height = @height) ->
    unless isNaN width
      @width = if width < 0 then 0 else width
      @right = @left + @width
      @view_right = @view_left + @width

    unless isNaN height
      @height = if height < 0 then 0 else height
      @bottom = @top + @height
      @view_bottom = @view_top + @height

  # alias for `resizeTo()`
  setSize: (width, height) -> @resizeTo width, height

  resizeBy: (width = 0, height = 0) ->
    unless isNaN width
      @width = @width + width
      @width = 0 if @width < 0
      @right = @left + @width
      @view_right = @view_left + @width

    unless isNaN height
      @height = @height + height
      @height = 0 if @height < 0
      @bottom = @top + @height
      @view_bottom = @view_top + @height

  setLeft: (position) ->
    diff = position - @left
    @left = position
    @width += diff
    @view_left += diff

  setRight: (position) ->
    diff = position - @right
    @right = position
    @width += diff
    @view_right += diff

  setTop: (position) ->
    diff = position - @top
    @top = position
    @height += diff
    @view_top += diff

  setBottom: (position) ->
    diff = position - @bottom
    @bottom = position
    @height += diff
    @view_bottom += diff

  # this makes debuging so much easier
  toString: ->
    result = {}
    result[property] = @[property] for property in @_properties
    JSON.stringify result
