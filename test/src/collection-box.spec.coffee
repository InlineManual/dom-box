createElement = (left, top, width, height) ->
  elm = document.createElement 'div'
  elm.style.position = 'absolute'
  elm.style.top = "#{top}px"
  elm.style.left = "#{left}px"
  elm.style.width = "#{width}px"
  elm.style.height = "#{height}px"
  elm.className = 'aaa'
  document.body.appendChild elm

describe 'Collection Box', ->

  elm1 = null
  elm2 = null
  box = null

  beforeEach ->
    elm1 = createElement 100, 100, 100, 100
    elm2 = createElement 200, 200, 300, 300
    box = new DomBox.CollectionBox '.aaa'

  afterEach ->
    elm1?.parentNode?.removeChild elm1
    elm2?.parentNode?.removeChild elm2

  it 'should be associated with a collection defined by selector', ->
    expect(box.selector).toEqual '.aaa'

  it 'should get bounding box data of all elements in collection', ->
    expect(box.width       ).toEqual 400
    expect(box.height      ).toEqual 400
    expect(box.left        ).toEqual 100
    expect(box.top         ).toEqual 100
    expect(box.right       ).toEqual 500
    expect(box.bottom      ).toEqual 500
    expect(box.view_left   ).toEqual 100
    expect(box.view_top    ).toEqual 100
    expect(box.view_right  ).toEqual 500
    expect(box.view_bottom ).toEqual 500

  it 'should get new data when list of elements in collection changes', ->
    elm1.parentNode.removeChild elm1
    box.update()
    expect(box.width       ).toEqual 300
    expect(box.height      ).toEqual 300
    expect(box.left        ).toEqual 200
    expect(box.top         ).toEqual 200
    expect(box.right       ).toEqual 500
    expect(box.bottom      ).toEqual 500
    expect(box.view_left   ).toEqual 200
    expect(box.view_top    ).toEqual 200
    expect(box.view_right  ).toEqual 500
    expect(box.view_bottom ).toEqual 500

  it 'should get zero data when collection is empty', ->
    elm1.parentNode.removeChild elm1
    elm2.parentNode.removeChild elm2
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

  it 'should handle empty selector without error', ->
    expect(-> new DomBox.CollectionBox null).not.toThrow()
    expect(-> new DomBox.CollectionBox '').not.toThrow()
