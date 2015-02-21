class DomBox.ElementBox extends DomBox.Box

  constructor: (@element) ->
    super()

  update: ->
    document_position = @getDocumentPosition @element
    box_data = @element.getBoundingClientRect()

    @width       = box_data.width ? @element.offsetWidth
    @height      = box_data.height ? @element.offsetHeight
    @left        = document_position.left
    @top         = document_position.top
    @right       = document_position.left + @width
    @bottom      = document_position.top + @height
    @view_left   = box_data.left
    @view_top    = box_data.top
    @view_right  = box_data.right
    @view_bottom = box_data.bottom

    super()

  # returns top and left position relative to document
  getDocumentPosition: (element) ->
    position =
      left: 0
      top: 0
    while element?
      position.left += element.offsetLeft
      position.top += element.offsetTop

      # adjust position for scrollable elements (e.g. `overflow: auto`)
      unless element is document.body
        position.left -= element.scrollLeft
        position.top -= element.scrollTop

      element = element.offsetParent
    position
