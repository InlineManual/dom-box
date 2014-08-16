describe 'Angles', ->

  it 'should convert radians to degrees', ->
    expect(radToDeg 0).toEqual 0
    expect(radToDeg Math.PI).toEqual 180

  it 'should convert degrees to radians', ->
    expect(degToRad 0).toEqual 0
    expect(degToRad 180).toEqual Math.PI

  describe 'normalize', ->

    it 'should leave angle within range 0 to 360 unchanged', ->
      expect(normalizeAngle 0).toEqual 0
      expect(normalizeAngle 90).toEqual 90
      expect(normalizeAngle 360).toEqual 0

    it 'should convert large angle', ->
      expect(normalizeAngle 450).toEqual 90

    it 'should convert negative angle', ->
      expect(normalizeAngle -90).toEqual 270
      expect(normalizeAngle -450).toEqual 270
