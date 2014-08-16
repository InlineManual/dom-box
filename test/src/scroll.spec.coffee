describe 'Scroll', ->

  beforeEach ->
    document.body.style.width = '1000px'
    document.body.style.height = '1000px'
    window.scrollTo 500, 500

  afterEach ->
    document.body.style.width = 'auto'
    document.body.style.height = 'auto'
    window.scrollTo 0,0

  it 'should exist', ->
    expect(DomBox.Scroll).toBeDefined()

  it 'should get left position', ->
    expect(DomBox.Scroll.getLeft()).toEqual 500

  it 'should get top position', ->
    expect(DomBox.Scroll.getTop()).toEqual 500

  it 'should position', ->
    position = DomBox.Scroll.getPosition()
    expect(position.left).toEqual 500
    expect(position.top).toEqual 500
