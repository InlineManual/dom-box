# Default viewport size of PhantomJS. It is hard to change it from within
# Jasmine, so I'll just use these in tests.
viewport_size =
  width: 400
  height: 300


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

  afterEach ->
    window.scrollTo 0, 0
    for element in document.querySelectorAll '.aaa'
      element.parentNode.removeChild element

  describe 'size methods', ->

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

    it 'should get box (including scroll position)', ->
      document.body.style.width = '1000px'
      document.body.style.height = '1000px'
      window.scrollTo 500, 500
      box = DomBox.Viewport.getBox()
      expect(box.width).toEqual viewport_size.width
      expect(box.height).toEqual viewport_size.height
      expect(box.top).toEqual 500
      expect(box.left).toEqual 500
      expect(box.bottom).toEqual 500 + viewport_size.height
      expect(box.right).toEqual 500 + viewport_size.width

  describe 'contains box', ->

    it 'should return true if box is completly within viewport', ->
      box = createBox 100, 100, 100, 100
      expect(DomBox.Viewport.contains box).toEqual true

    it 'should return false if box is partialy within viewport', ->
      box = createBox 350, 250, 100, 100
      expect(DomBox.Viewport.contains box).toEqual false

    it 'should return false if box is outside viewport', ->
      box = createBox 500, 500, 100, 100
      expect(DomBox.Viewport.contains box).toEqual false

  describe 'partialy contains box', ->

    it 'should return true if box is completly within viewport', ->
      box = createBox 100, 100, 100, 100
      expect(DomBox.Viewport.partialyContains box).toEqual true

    it 'should return true if box is partialy within viewport', ->
      box = createBox 350, 250, 100, 100
      expect(DomBox.Viewport.partialyContains box).toEqual true

    it 'should return false if box is outside viewport', ->
      box = createBox 500, 500, 100, 100
      expect(DomBox.Viewport.partialyContains box).toEqual false

  describe 'can contain box', ->

    it 'should return true if box is smaller than viewport', ->
      box = createBox 0, 0, 100, 100
      expect(DomBox.Viewport.canContain box).toEqual true

    it 'should return false if box is wider than viewport', ->
      box = createBox 0, 0, 1000, 100
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
