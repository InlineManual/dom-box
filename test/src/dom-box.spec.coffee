# Default viewport size of PhantomJS. It is hard to change it from within
# Jasmine, so I'll just use these in tests.
viewport_size =
  width: 400
  height: 300

createElement = (width, height, left, top, parent = document.body) ->
  attributes =
    position: 'absolute'
    width: "#{width}px"
    height: "#{height}px"
    left: "#{left}px"
    top: "#{top}px"
  element = document.createElement 'div'
  element.style[key] = val for key, val of attributes
  element.className = 'testElement'
  parent.appendChild element
  element

# Compares relevant properties (regarding size and position) of two Box objects.
# This is used to test, whether various method of getting Box object (selector,
# direct element reference, etc.) result in the same result.
testProperties = (box1, box2) ->
  properties = [
    'width', 'height'
    'left', 'top', 'right', 'bottom'
    'view_left', 'view_top', 'view_right', 'view_bottom'
  ]
  for property in properties
    return false if box1[property] isnt box2[property]
  return true

describe 'DomBox', ->

  elm1 = null
  elm2 = null
  elm3 = null
  b = null

  beforeEach ->

    document.body.style.padding = '0px'
    document.body.style.margin = '0px'
    document.body.style.width = '1000px'
    document.body.style.height = '1000px'
    window.scrollTo 100, 100

    # It looks like this. The box is document.Each character is 100*100px.
    # Symbol "x" is DIV element.
    #
    #     -----
    #    |     |
    #    | 1   |
    #    |   2 |
    #    |  3  |
    #    |     |
    #     -----
    #

    elm1 = createElement 100, 100, 100, 100
    elm1.className += ' elm'
    elm1.id = 'elm1'

    elm2 = createElement 100, 100, 300, 200
    elm2.className += ' elm'
    elm2.id = 'elm2'

    elm3 = createElement 100, 100, 200, 300
    elm3.className += ' elm'
    elm3.id = 'elm3'

    b = new DomBox.Box '#elm1'

  afterEach ->
    for element in document.querySelectorAll '.testElement'
      element.parentNode.removeChild element

  it 'should exist', ->
    expect(DomBox).toBeDefined()

  describe 'sanitize box', ->

    it 'should sanitize Box unchanged', ->
      result = DomBox.sanitizeBox b
      expect(testProperties result, b).toBe true

    it 'should sanitize string to Box', ->
      result = DomBox.sanitizeBox '#elm1'
      expect(testProperties result, b).toBe true

    it 'should sanitize element reference to Box', ->
      result = DomBox.sanitizeBox elm1
      expect(testProperties result, b).toBe true

  # viewport size is set in Gruntfile within `jasmine` task options
  describe 'viewport', ->

    it 'should get document size', ->
      width = DomBox.document.getWidth()
      expect(width).toEqual 1000

      height = DomBox.document.getHeight()
      # the extra pixels are there because of scrollbars
      expect(height).toBeGreaterThan 1000

      size = DomBox.document.getSize()
      expect(size.width).toEqual width
      expect(size.height).toEqual height

    it 'should get scroll position', ->
      left = DomBox.scroll.getLeft()
      expect(left).toEqual 100

      top = DomBox.scroll.getTop()
      expect(top).toEqual 100

      position = DomBox.scroll.getPosition()
      expect(position.left).toEqual left
      expect(position.top).toEqual top

    it 'should get viewport size', ->
      width = DomBox.viewport.getWidth()
      expect(width).toEqual viewport_size.width

      height = DomBox.viewport.getHeight()
      expect(height).toEqual viewport_size.height

      size = DomBox.viewport.getSize()
      expect(size.width).toEqual width
      expect(size.height).toEqual height

    it 'should get viewport box', ->
      box = DomBox.viewport.getBox()
      expect(box.width).toEqual viewport_size.width
      expect(box.height).toEqual viewport_size.height
      expect(box.left).toEqual 100
      expect(box.top).toEqual 100
      expect(box.right).toEqual 500
      expect(box.bottom).toEqual 400

  describe 'Box', ->

    it 'should be created with zero values if selector returns no elements', ->
      b = new DomBox.Box()
      expect(b.width).toEqual 0
      expect(b.height).toEqual 0
      expect(b.left).toEqual 0
      expect(b.top).toEqual 0
      expect(b.right).toEqual 0
      expect(b.bottom).toEqual 0
      expect(b.view_left).toEqual 0
      expect(b.view_top).toEqual 0
      expect(b.view_right).toEqual 0
      expect(b.view_bottom).toEqual 0

    it 'should be created with zero values if selector is empty string', ->
      b = new DomBox.Box ''
      expect(b.width).toEqual 0
      expect(b.height).toEqual 0
      expect(b.left).toEqual 0
      expect(b.top).toEqual 0
      expect(b.right).toEqual 0
      expect(b.bottom).toEqual 0
      expect(b.view_left).toEqual 0
      expect(b.view_top).toEqual 0
      expect(b.view_right).toEqual 0
      expect(b.view_bottom).toEqual 0

    it 'should get get values for single element', ->
      b = new DomBox.Box '#elm1'
      expect(b.width).toEqual 100
      expect(b.height).toEqual 100
      expect(b.left).toEqual 100
      expect(b.top).toEqual 100
      expect(b.right).toEqual 200
      expect(b.bottom).toEqual 200
      expect(b.view_left).toEqual 0
      expect(b.view_top).toEqual 0
      expect(b.view_right).toEqual 100
      expect(b.view_bottom).toEqual 100

    it 'should get values for collection of elements', ->
      b = new DomBox.Box '.elm'
      expect(b.width).toEqual 300
      expect(b.height).toEqual 300
      expect(b.left).toEqual 100
      expect(b.top).toEqual 100
      expect(b.right).toEqual 400
      expect(b.bottom).toEqual 400
      expect(b.view_left).toEqual 0
      expect(b.view_top).toEqual 0
      expect(b.view_right).toEqual 300
      expect(b.view_bottom).toEqual 300

    it 'should get pivot', ->
      pivot = b.getPivot()
      expect(pivot.left).toEqual 150
      expect(pivot.top).toEqual 150

    it 'should add padding', ->
      padded_box = b.pad 50
      expect(padded_box.width).toEqual 200
      expect(padded_box.height).toEqual 200
      expect(padded_box.left).toEqual 50
      expect(padded_box.top).toEqual 50
      expect(padded_box.right).toEqual 250
      expect(padded_box.bottom).toEqual 250
      expect(padded_box.view_left).toEqual -50
      expect(padded_box.view_top).toEqual -50
      expect(padded_box.view_right).toEqual 150
      expect(padded_box.view_bottom).toEqual 150

  describe 'box relative to viewport', ->

    it 'should detect if is within viewport', ->
      window.scrollTo 0, 0
      expect(b.isInViewport()).toBe true
      window.scrollTo 150, 150
      expect(b.isInViewport()).toBe false
      window.scrollTo 300, 300
      expect(b.isInViewport()).toBe false

    it 'should detect if element far to the right is in viewport', ->
      window.scrollTo 0, 0
      elm = createElement 100, 100, 999999, 0
      b = new DomBox.Box elm
      expect(b.isInViewport()).toEqual false

    it 'should detect if element far to the bottom is in viewport', ->
      window.scrollTo 0, 0
      elm = createElement 100, 100, 0, 999999
      b = new DomBox.Box elm
      expect(b.isInViewport()).toEqual false

    it 'should detect if is partialy within viewport', ->
      window.scrollTo 0, 0
      expect(b.isPartialyInViewport()).toBe true
      window.scrollTo 150, 150
      expect(b.isPartialyInViewport()).toBe true
      window.scrollTo 300, 300
      expect(b.isPartialyInViewport()).toBe false

    it 'should detect if is bigger than viewport (thus impossible to fit)', ->
      expect(b.canFitViewport()).toBe true
      elm1.style.width = '100000px'
      elm1.style.height = '100000px'
      expect(b.canFitViewport()).toBe false

  describe 'box relations', ->

    reference = null
    complete_overlap = null
    partial_overlap = null
    touching_side = null
    touching_corner = null
    no_overlap = null

    beforeEach ->
      reference = createElement 100, 100, 0, 0
      complete_overlap = createElement 100, 100, 0, 0
      partial_overlap = createElement 100, 100, 50, 50
      touching_side = createElement 100, 100, 100, 0
      touching_corner = createElement 100, 100, 100, 100
      no_overlap = createElement 100, 100, 200, 200

    afterEach ->
      for element in document.querySelectorAll '.testElement'
        element.parentNode.removeChild element

    it 'should detect if elements are coliding', ->
      expect(DomBox.detectOverlap reference, complete_overlap).toBe true
      expect(DomBox.detectOverlap reference, partial_overlap).toBe true
      expect(DomBox.detectOverlap reference, touching_side).toBe false
      expect(DomBox.detectOverlap reference, touching_corner).toBe false
      expect(DomBox.detectOverlap reference, no_overlap).toBe false

    it 'should get distance between elements (width, height)', ->
      expect(DomBox.getDistance reference, complete_overlap).toEqual
        horizontal: -100
        vertical:   -100

      expect(DomBox.getDistance reference, partial_overlap).toEqual
        horizontal: -50
        vertical:   -50

      expect(DomBox.getDistance reference, touching_side).toEqual
        horizontal: 0
        vertical:   -100

      expect(DomBox.getDistance reference, touching_corner).toEqual
        horizontal: 0
        vertical:   0

      expect(DomBox.getDistance reference, no_overlap).toEqual
        horizontal: 100
        vertical:   100

    it 'should get distance between pivots', ->
      expect(DomBox.getPivotDistance reference, complete_overlap)
        .toEqual 0
      expect(DomBox.getPivotDistance reference, partial_overlap)
        .toBeLessThan 100
      expect(DomBox.getPivotDistance reference, touching_side)
        .toEqual 100
      expect(DomBox.getPivotDistance reference, touching_corner)
        .toBeGreaterThan 100

    it 'should get angle between pivots of elements', ->
      expect(DomBox.getPivotAngle reference, complete_overlap).toEqual 0
      expect(DomBox.getPivotAngle reference, partial_overlap).toEqual 45
      expect(DomBox.getPivotAngle reference, touching_side).toEqual 0

    it 'should get relative direction between elements', ->
      ref = createElement 100, 100, 200, 200

      elm = createElement 100, 100, 0, 0
      expect(DomBox.getRelativeDirection ref, elm).toEqual 'top left'

      elm = createElement 100, 100, 200, 0
      expect(DomBox.getRelativeDirection ref, elm).toEqual 'top'

      elm = createElement 100, 100, 400, 0
      expect(DomBox.getRelativeDirection ref, elm).toEqual 'top right'

      elm = createElement 100, 100, 400, 200
      expect(DomBox.getRelativeDirection ref, elm).toEqual 'right'

      elm = createElement 100, 100, 400, 400
      expect(DomBox.getRelativeDirection ref, elm).toEqual 'bottom right'

      elm = createElement 100, 100, 200, 400
      expect(DomBox.getRelativeDirection ref, elm).toEqual 'bottom'

      elm = createElement 100, 100, 0, 400
      expect(DomBox.getRelativeDirection ref, elm).toEqual 'bottom left'

      elm = createElement 100, 100, 0, 200
      expect(DomBox.getRelativeDirection ref, elm).toEqual 'left'

    it 'should detect if boxes can fit into viewport without overlaping', ->
      # Reference element is positioned so that there is not enough room beside
      # it for medium element if we lock the horizontal scroll.
      ref_element = createElement 100, 100, 100, 100
      small_element = createElement 100, 100, 0, 0
      medium_element = createElement 300, 200, 0, 0
      big_element = createElement 10000, 10000, 0, 0

      expect(DomBox.canCoexist ref_element, small_element, false).toBe true
      expect(DomBox.canCoexist ref_element, small_element, true).toBe true
      expect(DomBox.canCoexist ref_element, medium_element, false).toBe true
      expect(DomBox.canCoexist ref_element, medium_element, true).toBe false
      expect(DomBox.canCoexist ref_element, big_element, false).toBe false
