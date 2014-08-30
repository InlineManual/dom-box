describe 'Box transformations', ->

  box = null
  elm = null

  beforeEach ->
    # enlarge BODY and scroll it a little bit
    document.body.style.width = '10000px'
    document.body.style.height = '10000px'
    window.scrollTo 50, 50

    # create test element
    elm = document.createElement 'div'
    elm.style.position = 'absolute'
    elm.style.top = '100px'
    elm.style.left = '200px'
    elm.style.width = '300px'
    elm.style.height = '400px'
    document.body.appendChild elm

    # create test ElementBox
    box = new DomBox.ElementBox elm

  afterEach ->
    # remove element if it exists
    elm?.parentNode?.removeChild elm

    # scroll back
    window.scrollTo 0, 0

  describe 'Move to', ->

    it 'should move box to target coordinates', ->
      box.moveTo 100, 100
      expect(box.left).toEqual 100
      expect(box.top).toEqual 100
      expect(box.right).toEqual 400
      expect(box.bottom).toEqual 500
      expect(box.view_left).toEqual 50
      expect(box.view_top).toEqual 50
      expect(box.view_right).toEqual 350
      expect(box.view_bottom).toEqual 450

    it 'should accept negative values', ->
      box.moveTo -100, -100
      expect(box.left).toEqual -100
      expect(box.top).toEqual -100

    it 'should leave position unchanged on `null`', ->
      box.moveTo()
      expect(box.left).toEqual 200
      expect(box.top).toEqual 100

    it 'should leave position unchanged on invalid value', ->
      box.moveTo 'xxx', 'yyy'
      expect(box.left).toEqual 200
      expect(box.top).toEqual 100

  describe 'Move by', ->

    it 'should move box by distance', ->
      box.moveBy 100, 100
      expect(box.left).toEqual 300
      expect(box.top).toEqual 200
      expect(box.right).toEqual 600
      expect(box.bottom).toEqual 600
      expect(box.view_left).toEqual 250
      expect(box.view_top).toEqual 150
      expect(box.view_right).toEqual 550
      expect(box.view_bottom).toEqual 550

    it 'should accept negative values', ->
      box.moveBy -100, -100
      expect(box.left).toEqual 100
      expect(box.top).toEqual 0

    it 'should leave position unchanged on `null`', ->
      box.moveBy()
      expect(box.left).toEqual 200
      expect(box.top).toEqual 100

    it 'should leave position unchanged on invalid value', ->
      box.moveBy 'xxx', 'yyy'
      expect(box.left).toEqual 200
      expect(box.top).toEqual 100

  describe 'Resize to', ->

    it 'should resize box to new size', ->
      box.resizeTo 100, 100
      expect(box.width).toEqual 100
      expect(box.height).toEqual 100
      expect(box.left).toEqual 200
      expect(box.top).toEqual 100
      expect(box.right).toEqual 300
      expect(box.bottom).toEqual 200
      expect(box.view_left).toEqual 150
      expect(box.view_top).toEqual 50
      expect(box.view_right).toEqual 250
      expect(box.view_bottom).toEqual 150

    it 'should transform negative values to zero', ->
      box.resizeTo -100, -100
      expect(box.width).toEqual 0
      expect(box.height).toEqual 0

    it 'should leave size unchanged on `null`', ->
      box.resizeTo()
      expect(box.width).toEqual 300
      expect(box.height).toEqual 400

    it 'should leave size unchanged on invalid value', ->
      box.resizeTo 'xxx', 'yyy'
      expect(box.width).toEqual 300
      expect(box.height).toEqual 400


  describe 'Resize by', ->

    it 'should resize box by distance', ->
      box.resizeBy 100, 100
      expect(box.width).toEqual 400
      expect(box.height).toEqual 500
      expect(box.left).toEqual 200
      expect(box.top).toEqual 100
      expect(box.right).toEqual 600
      expect(box.bottom).toEqual 600
      expect(box.view_left).toEqual 150
      expect(box.view_top).toEqual 50
      expect(box.view_right).toEqual 550
      expect(box.view_bottom).toEqual 550

    it 'should accept negative values', ->
      box.resizeBy -100, -100
      expect(box.width).toEqual 200
      expect(box.height).toEqual 300

    it 'should not set size smaller than zero', ->
      box.resizeBy -1000, -1000
      expect(box.width).toEqual 0
      expect(box.height).toEqual 0

    it 'should leave size unchanged on `null`', ->
      box.resizeBy()
      expect(box.width).toEqual 300
      expect(box.height).toEqual 400

    it 'should leave size unchanged on invalid value', ->
      box.resizeBy 'xxx', 'yyy'
      expect(box.width).toEqual 300
      expect(box.height).toEqual 400
