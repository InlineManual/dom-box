describe 'Document', ->

  beforeEach ->
    document.body.style.margin = '0'
    document.body.style.width = '10000px'
    document.body.style.height = '10000px'

  afterEach ->
    document.body.style.width = 'auto'
    document.body.style.height = 'auto'

  it 'should exist', ->
    expect(DomBox.Document).toBeDefined()

  it 'should get width', ->
    expect(DomBox.Document.getWidth()).toEqual 10000

  it 'should get height', ->
    # TODO This is not exact. Investigate difference between scrollHeight and
    # offsetHeight.
    expect(DomBox.Document.getHeight()).toBeGreaterThan 9999

  it 'should get size', ->
    result = DomBox.Document.getSize()
    expect(result.width).toEqual 10000
    expect(result.height).toBeGreaterThan 9999
