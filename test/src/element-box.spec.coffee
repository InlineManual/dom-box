describe 'Element Box', ->

  elm = null
  box = null

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

    # set BODY back to its original size
    window.scrollTo 0, 0
    document.body.style.width = 'auto'
    document.body.style.height = 'auto'

  it 'should be associated with an element', ->
    expect(box.element).toEqual elm

  describe 'box data on init', ->

    it 'should get width', ->
      expect(box.width       ).toEqual 300

    it 'should get height', ->
      expect(box.height      ).toEqual 400

    it 'should get left', ->
      expect(box.left        ).toEqual 200

    it 'should get top', ->
      expect(box.top         ).toEqual 100

    it 'should get right', ->
      expect(box.right       ).toEqual 500

    it 'should get bottom', ->
      expect(box.bottom      ).toEqual 500

    it 'should get view_left', ->
      expect(box.view_left   ).toEqual 150

    it 'should get view_top', ->
      expect(box.view_top    ).toEqual  50

    it 'should get view_right', ->
      expect(box.view_right  ).toEqual 450

    it 'should get view_bottom', ->
      expect(box.view_bottom ).toEqual 450

  it 'should update box data', ->
    elm.style.width = '800px'
    elm.style.height = '900px'
    box.update()

    expect(box.width).toEqual 800
    expect(box.height).toEqual 900

  it 'should zero values if associated element does not exist', ->
    elm.parentNode.removeChild elm
    box.update()

    expect(box.width       ).toEqual 0
    expect(box.height      ).toEqual 0
    expect(box.left        ).toEqual 0
    expect(box.top         ).toEqual 0
    expect(box.right       ).toEqual 0
    expect(box.bottom      ).toEqual 0
    expect(box.view_left   ).toEqual 0
    expect(box.view_top    ).toEqual 0
    expect(box.view_right  ).toEqual 0
    expect(box.view_bottom ).toEqual 0
