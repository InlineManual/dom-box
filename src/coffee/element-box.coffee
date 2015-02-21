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

    # Take all parent nodes' scroll position into account (e.g. elements with
    # `overflow: auto`). This can apply to any parent element, even the
    # non-positioned ones.
    scroll_element = element?.parentNode
    while scroll_element? and scroll_element isnt document.body
      position.left -= scroll_element.scrollLeft
      position.top -= scroll_element.scrollTop
      scroll_element = scroll_element.parentNode

    # Take parents' offset into account. This only applies to positioned
    # parents.
    offset_element = element
    while offset_element?

      # TODO sticky element

      # fixed element
      if @getCssProperty(element, 'position') is 'fixed'
        viewport_position = DomBox.Viewport.getPosition()
        position.left += offset_element.offsetLeft + viewport_position.left
        position.top += offset_element.offsetTop + viewport_position.top
        # fixed element's position is not affected by positions of its parents
        offset_element = null

      # absolute and relative elements
      else
        position.left += offset_element.offsetLeft
        position.top += offset_element.offsetTop
        offset_element = offset_element.offsetParent

    position

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
