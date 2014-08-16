describe '`isElement()`', ->

  describe 'should return false on', ->

    it 'no input', ->
      expect(isElement()).toEqual false

    it '`null`', ->
      expect(isElement null).toEqual false

    it 'Boolean', ->
      expect(isElement false).toEqual false
      expect(isElement true).toEqual false

    it 'Number', ->
      expect(isElement 1).toEqual false
      expect(isElement 1.23).toEqual false

    it 'String', ->
      expect(isElement 'aaa').toEqual false

    it 'Array', ->
      expect(isElement []).toEqual false
      expect(isElement ['aaa', 'bbb']).toEqual false

    it 'Object', ->
      expect(isElement {}).toEqual false
      expect(isElement {aaa: 'bbb'}).toEqual false

    it 'TextNode', ->
      dummy = document.body.appendChild document.createTextNode 'aaa'
      expect(isElement dummy).toEqual false

    it 'document fragment', ->
      dummy = document.body.appendChild document.createDocumentFragment()
      expect(isElement dummy).toEqual false


  describe 'should return true on', ->

    it 'HTML Element', ->
      dummy = document.body.appendChild document.createElement 'div'
      expect(isElement dummy).toEqual true

    it 'SVG Element', ->
      dummy = document.createElementNS 'http://www.w3.org/2000/svg', 'svg'
      document.body.appendChild dummy
      expect(isElement dummy).toEqual true
