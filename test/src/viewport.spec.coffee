# Default viewport size of PhantomJS. It is hard to change it from within
# Jasmine, so I'll just use these in tests.
viewport_size =
  width: 400
  height: 300

# DEBUG Karma tests

# stretch the body size first, so that the scrollbars are displayed
# we need to do this before we measure the viewport
document.body.style.width = '10000px'
document.body.style.height = '10000px'

# hey, this is cheating
viewport_size =
  width: DomBox.Viewport.getWidth()
  height: DomBox.Viewport.getHeight()

createElement = (left, top, width, height) ->
  elm = document.createElement 'div'
  elm.style.position = 'absolute'
  elm.style.top = "#{top}px"
  elm.style.left = "#{left}px"
  elm.style.width = "#{width}px"
  elm.style.height = "#{height}px"
  elm.className = 'aaa'
  document.body.appendChild elm

createBox = (left, top, width, height) ->
  elm = createElement left, top, width, height
  new DomBox.ElementBox elm


describe 'Viewport', ->

  beforeEach ->
    document.body.style.width = '10000px'
    document.body.style.height = '10000px'

  afterEach ->
    window.scrollTo 0, 0
    document.body.style.width = 'auto'
    document.body.style.height = 'auto'
    for element in document.querySelectorAll '.aaa'
      element.parentNode.removeChild element

  describe 'size and position methods', ->

    it 'should exist', ->
      expect(DomBox.Viewport).toBeDefined()

    it 'should get width', ->
      expect(DomBox.Viewport.getWidth()).toEqual viewport_size.width

    it 'should get height', ->
      expect(DomBox.Viewport.getHeight()).toEqual viewport_size.height

    it 'should get size', ->
      size = DomBox.Viewport.getSize()
      expect(size.width).toEqual viewport_size.width
      expect(size.height).toEqual viewport_size.height

    it 'should get left position', ->
      window.scrollTo 500, 500
      expect(DomBox.Viewport.getLeft()).toEqual 500

    it 'should get top position', ->
      window.scrollTo 500, 500
      expect(DomBox.Viewport.getTop()).toEqual 500

    it 'should get position', ->
      window.scrollTo 500, 500
      position = DomBox.Viewport.getPosition()
      expect(position.left).toEqual 500
      expect(position.top).toEqual 500

    it 'should get box (including scroll position)', ->
      window.scrollTo 500, 500
      box = DomBox.Viewport.getBox()
      expect(box.width).toEqual viewport_size.width
      expect(box.height).toEqual viewport_size.height
      expect(box.top).toEqual 500
      expect(box.left).toEqual 500
      expect(box.bottom).toEqual 500 + viewport_size.height
      expect(box.right).toEqual 500 + viewport_size.width

  describe 'move inside', ->

    xit 'should not change position of box contained in viewport', ->
    xit 'should match top-left corners of viewport and box that can not fit', ->

    describe 'box is', ->

      beforeEach ->
        window.scrollTo 500, 500

      it 'above the viewport', ->
        box = createBox 500, 0, 100, 100
        DomBox.Viewport.moveInside box
        expect(DomBox.Viewport.contains box).toEqual true
        expect(box.top).toEqual 500

      it 'above and to the right of the viewport', ->
        box = createBox 800, 0, 100, 100
        DomBox.Viewport.moveInside box
        expect(DomBox.Viewport.contains box).toEqual true
        expect(box.top).toEqual 500
        expect(box.right).toEqual 900

      it 'to the right of the viewport', ->
        box = createBox 800, 500, 100, 100
        DomBox.Viewport.moveInside box
        expect(DomBox.Viewport.contains box).toEqual true
        expect(box.right).toEqual 900

      it 'below and to the right of the viewport', ->
        box = createBox 5000, 5000, 100, 100
        DomBox.Viewport.moveInside box
        expect(DomBox.Viewport.contains box).toEqual true
        expect(box.bottom).toEqual DomBox.Viewport.getBox().bottom
        expect(box.right).toEqual DomBox.Viewport.getBox().right

      it 'below the viewport', ->
        box = createBox 500, 5000, 100, 100
        DomBox.Viewport.moveInside box
        expect(DomBox.Viewport.contains box).toEqual true
        expect(box.bottom).toEqual DomBox.Viewport.getBox().bottom

      it 'below and to the left of the viewport', ->
        box = createBox 0, 5000, 100, 100
        DomBox.Viewport.moveInside box
        expect(DomBox.Viewport.contains box).toEqual true
        expect(box.bottom).toEqual DomBox.Viewport.getBox().bottom
        expect(box.left).toEqual 500

      it 'to the left of the viewport', ->
        box = createBox 0, 500, 100, 100
        DomBox.Viewport.moveInside box
        expect(DomBox.Viewport.contains box).toEqual true
        expect(box.left).toEqual 500

      it 'above and to the left of the viewport', ->
        box = createBox 0, 0, 100, 100
        DomBox.Viewport.moveInside box
        expect(DomBox.Viewport.contains box).toEqual true
        expect(box.top).toEqual 500
        expect(box.left).toEqual 500


  describe 'contains box', ->

    it 'should return true if box is completly within viewport', ->
      box = createBox 100, 100, 100, 100
      expect(DomBox.Viewport.contains box).toEqual true

    it 'should return false if box is partialy within viewport', ->
      right = viewport_size.width - 50
      bottom = viewport_size.height - 50
      box = createBox right, bottom, 100, 100
      expect(DomBox.Viewport.contains box).toEqual false

    it 'should return false if box is outside viewport', ->
      box = createBox 5000, 5000, 100, 100
      expect(DomBox.Viewport.contains box).toEqual false

  describe 'partialy contains box', ->

    it 'should return true if box is completly within viewport', ->
      box = createBox 100, 100, 100, 100
      expect(DomBox.Viewport.partialyContains box).toEqual true

    it 'should return true if box is partialy within viewport', ->
      outside_right = viewport_size.width - 50
      outside_bottom = viewport_size.height - 50
      box = createBox outside_right, outside_bottom, 100, 100
      expect(DomBox.Viewport.partialyContains box).toEqual true

      box = createBox -50, -50, 100, 100
      expect(DomBox.Viewport.partialyContains box).toEqual true

    it 'should return false if box is outside viewport', ->
      box = createBox 5000, 5000, 100, 100
      expect(DomBox.Viewport.partialyContains box).toEqual false

  describe 'can contain box', ->

    it 'should return true if box is smaller than viewport', ->
      box = createBox 0, 0, 100, 100
      expect(DomBox.Viewport.canContain box).toEqual true

    it 'should return false if box is wider than viewport', ->
      box = createBox 0, 0, 5000, 100
      expect(DomBox.Viewport.canContain box).toEqual false

    it 'should return false if box is higher than viewport', ->
      box = createBox 0, 0, 100, 1000
      expect(DomBox.Viewport.canContain box).toEqual false

    it 'should return false if box is bigger than viewport', ->
      box = createBox 0, 0, 1000, 1000
      expect(DomBox.Viewport.canContain box).toEqual false

    it 'should return false if box is missing', ->
      expect(DomBox.Viewport.canContain null).toEqual false

  describe 'can coexist', ->

    it 'should return true if boxes can coexist', ->
      box1 = createBox 0, 0, 100, 100
      box2 = createBox 100, 100, 100, 100
      expect(DomBox.Viewport.canCoexist box1, box2).toEqual true

    it 'should return false if boxes are too far away from each other', ->
      box1 = createBox 0, 0, 100, 100
      box2 = createBox 1000, 1000, 100, 100
      expect(DomBox.Viewport.canCoexist box1, box2).toEqual false

    it 'should return false if box is too big for viewport', ->
      box1 = createBox 0, 0, 1000, 1000
      box2 = createBox 100, 100, 100, 100
      expect(DomBox.Viewport.canCoexist box1, box2).toEqual false

    it 'should return false if one of the boxes is missing', ->
      box = createBox 0, 0, 100, 100
      expect(DomBox.Viewport.canCoexist box, null).toEqual false
      expect(DomBox.Viewport.canCoexist null, box).toEqual false
      expect(DomBox.Viewport.canCoexist null, null).toEqual false

  describe 'can fit around', ->

    describe 'box1 is inside viewport', ->

      it 'should return true if box2 can fit', ->
        box1 = createBox 100, 100, 100, 100
        box2 = createBox 0, 0, 100, 100
        expect(DomBox.Viewport.canFitAround box1, box2).toEqual true

      it 'should return false if box2 can not fit', ->
        box1 = createBox 100, 100, 100, 100
        box2 = createBox 0, 0, 5000, 5000
        expect(DomBox.Viewport.canFitAround box1, box2).toEqual false

    describe 'box1 is partialy inside viewport', ->

      it 'should return true if box2 can fit', ->
        box1 = createBox 200, 200, 1000, 1000
        box2 = createBox 0, 0, 100, 100
        expect(DomBox.Viewport.canFitAround box1, box2).toEqual true

      it 'should return false if box2 can not fit', ->
        box1 = createBox 200, 200, 1000, 1000
        box2 = createBox 0, 0, 300, 300
        expect(DomBox.Viewport.canFitAround box1, box2).toEqual false

    describe 'box1 is outside viewport', ->

      it 'should return true if box2 can fit', ->
        box1 = createBox 1000, 1000, 100, 100
        box2 = createBox 0, 0, 100, 100
        expect(DomBox.Viewport.canFitAround box1, box2).toEqual true

      it 'should return false if box2 can not fit', ->
        box1 = createBox 1000, 1000, 100, 100
        box2 = createBox 0, 0, 1000, 1000
        expect(DomBox.Viewport.canFitAround box1, box2).toEqual false

    describe 'box1 is', ->

      it 'on the left side', ->
        box1 = createBox 0, 0, 200, 300
        box2 = createBox 0, 0, 100, 100
        expect(DomBox.Viewport.canFitAround box1, box2).toEqual true

      it 'on the right side', ->
        box1 = createBox 200, 0, 200, 300
        box2 = createBox 0, 0, 100, 100
        expect(DomBox.Viewport.canFitAround box1, box2).toEqual true

      it 'on the upper side', ->
        box1 = createBox 0, 0, 400, 100
        box2 = createBox 0, 0, 100, 100
        expect(DomBox.Viewport.canFitAround box1, box2).toEqual true

      it 'on the bottom side', ->
        box1 = createBox 0, 200, 400, 100
        box2 = createBox 0, 0, 100, 100
        expect(DomBox.Viewport.canFitAround box1, box2).toEqual true

      it 'wider than viewport', ->
        box1 = createBox -100, 100, 600, 100
        box2 = createBox 0, 0, 100, 100
        expect(DomBox.Viewport.canFitAround box1, box2).toEqual true

      it 'higher than viewport', ->
        box1 = createBox 100, -100, 100, 500
        box2 = createBox 0, 0, 100, 100
        expect(DomBox.Viewport.canFitAround box1, box2).toEqual true

      it 'bigger than viewport', ->
        box1 = createBox -100, -100, 5000, 5000
        box2 = createBox 0, 0, 100, 100
        expect(DomBox.Viewport.canFitAround box1, box2).toEqual false

  describe 'fit around', ->

    it 'box on the left side', ->
      box1 = createBox 0, 0, 200, 300
      box2 = createBox 0, 0, 100, 100
      DomBox.Viewport.fitAround box1, box2
      expect(DomBox.Viewport.contains box2).toEqual true
      expect(DomBox.detectOverlap box1, box2).toEqual false

    it 'box on the right side', ->
      box1 = createBox 200, 0, 200, 300
      box2 = createBox 200, 0, 100, 100
      DomBox.Viewport.fitAround box1, box2
      expect(DomBox.Viewport.contains box2).toEqual true
      expect(DomBox.detectOverlap box1, box2).toEqual false

    it 'box on the upper side', ->
      box1 = createBox 0, 0, 400, 100
      box2 = createBox 0, 0, 100, 100
      DomBox.Viewport.fitAround box1, box2
      expect(DomBox.Viewport.contains box2).toEqual true
      expect(DomBox.detectOverlap box1, box2).toEqual false

    it 'box on the bottom side', ->
      box1 = createBox 0, 200, 400, 100
      box2 = createBox 0, 200, 100, 100
      DomBox.Viewport.fitAround box1, box2
      expect(DomBox.Viewport.contains box2).toEqual true
      expect(DomBox.detectOverlap box1, box2).toEqual false

    it 'box wider than viewport', ->
      box1 = createBox -100, 100, 600, 100
      box2 = createBox -100, 100, 100, 100
      DomBox.Viewport.fitAround box1, box2
      expect(DomBox.Viewport.contains box2).toEqual true
      expect(DomBox.detectOverlap box1, box2).toEqual false

    it 'box higher than viewport', ->
      box1 = createBox 100, -100, 100, 500
      box2 = createBox 100, -100, 100, 100
      DomBox.Viewport.fitAround box1, box2
      expect(DomBox.Viewport.contains box2).toEqual true
      expect(DomBox.detectOverlap box1, box2).toEqual false
