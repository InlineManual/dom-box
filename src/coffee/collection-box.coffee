class DomBox.CollectionBox extends DomBox.Box

  constructor: (@selector) ->
    super()

  update: ->
    boxes = []

    # Do not try to get elements if selector is empty. That would throw an error
    if @selector
      for element in document.querySelectorAll @selector
        boxes.push new DomBox.ElementBox element

    # If boxes list is empty, insert a default Box to get zero results.
    if boxes.length is 0
      boxes.push new DomBox.Box

    for property, value of getExtremes boxes
      @[property] = value

    super()
