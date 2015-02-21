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
      expect(box.width       ).toBe 300

    it 'should get height', ->
      expect(box.height      ).toBe 400

    it 'should get left', ->
      expect(box.left        ).toBe 200

    it 'should get top', ->
      expect(box.top         ).toBe 100

    it 'should get right', ->
      expect(box.right       ).toBe 500

    it 'should get bottom', ->
      expect(box.bottom      ).toBe 500

    it 'should get view_left', ->
      expect(box.view_left   ).toBe 150

    it 'should get view_top', ->
      expect(box.view_top    ).toBe  50

    it 'should get view_right', ->
      expect(box.view_right  ).toBe 450

    it 'should get view_bottom', ->
      expect(box.view_bottom ).toBe 450

  it 'should update box data', ->
    elm.style.width = '800px'
    elm.style.height = '900px'
    box.update()

    expect(box.width).toEqual 800
    expect(box.height).toEqual 900

  it 'should have zero values if associated element does not exist', ->
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

  it 'should correctly calculate size of box styled by external stylesheet', ->
    elm = document.createElement 'div'
    elm.className = 'aaa'
    document.body.appendChild elm

    box = new DomBox.ElementBox elm
    expect(box.width).toEqual 100
    expect(box.height).toEqual 100


  describe 'element inside scrollable element', ->

    elm_wrapper = null
    elm_content = null
    elm_anchor = null

    beforeAll ->
      wrapper_attributes =
        position: 'absolute'
        left: '100px'
        top: '100px'
        width: '100px'
        height: '100px'
        overflow: 'auto'
      elm_wrapper = document.body.appendChild document.createElement 'div'
      for key, val of wrapper_attributes
        elm_wrapper.style[key] = val

      content_attributes =
        width: '1000px'
        height: '1000px'
        position: 'relative'
      elm_content = elm_wrapper.appendChild document.createElement 'div'
      for key, val of wrapper_attributes
        elm_content.style[key] = val

      anchor_attributes =
        width: '100px'
        height: '100px'
        position: 'absolute'
        top: '500px'
        left: '500px'
      elm_anchor = elm_content.appendChild document.createElement 'div'
      for key, val of wrapper_attributes
        elm_anchor.style[key] = val

      elm_anchor.scrollIntoView();

    afterAll ->
      elm_wrapper.parentNode.removeChild elm_wrapper


    it 'should get document position', ->
      box = DomBox.getBox elm_anchor
      expect(box.top).toEqual 100


  describe 'element with fixed position', ->

    elm2 = null

    beforeEach ->
      elm.style.position = 'fixed'
      # inner element
      elm2 = elm.appendChild document.createElement 'div'
      elm2.style.position = 'absolute'
      elm2.style.left = '100px'
      elm2.style.top = '100px'
      elm2.style.width = '100px'
      elm2.style.height = '100px'

    it 'should get position', ->
      window.scrollTo 0, 0
      box = DomBox.getBox elm
      expect(box.top).toEqual 100
      expect(box.left).toEqual 200

    it 'should get position after scroll', ->
      window.scrollTo 200, 200
      box = DomBox.getBox elm
      expect(box.top).toEqual 300
      expect(box.left).toEqual 400

    it 'should get position of positioned element inside fixed one', ->
      window.scrollTo 0, 0
      box = DomBox.getBox elm2
      expect(box.top).toEqual 200
      expect(box.left).toEqual 300

    it 'should get position of positioned elm inside fixed one after scroll', ->
      window.scrollTo 200, 200
      box = DomBox.getBox elm2
      expect(box.top).toEqual 400
      expect(box.left).toEqual 500
