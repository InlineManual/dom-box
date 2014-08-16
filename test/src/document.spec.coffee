describe 'Document', ->

  beforeEach ->
    document.body.style.margin = '0'
    document.body.style.width = '1000px'
    document.body.style.height = '1000px'

  afterEach ->
    document.body.style.width = 'auto'
    document.body.style.height = 'auto'

  it 'should exist', ->
    expect(DomBox.Document).toBeDefined()

  it 'should get width', ->
    expect(DomBox.Document.getWidth()).toEqual 1000

  it 'should get height', ->
    # TODO This is not exact. Investigate difference between scrollHeight and
    # offsetHeight.
    expect(DomBox.Document.getHeight()).toBeGreaterThan 1000

  it 'should get size', ->
    result = DomBox.Document.getSize()
    expect(result.width).toEqual 1000
    expect(result.height).toBeGreaterThan 1000
