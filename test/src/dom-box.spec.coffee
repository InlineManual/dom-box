createElement = (left = 0, top = 0, width = 100, height = 100) ->
  elm = document.createElement 'div'
  elm.style.position = 'absolute'
  elm.style.top = "#{top}px"
  elm.style.left = "#{left}px"
  elm.style.width = "#{width}px"
  elm.style.height = "#{height}px"
  elm.className = 'aaa'
  document.body.appendChild elm


describe 'DomBox', ->

  describe 'getBox()', ->

    it 'should return null when called with no or invalid parameter', ->
      box = DomBox.getBox null
      expect(box).toEqual null

    it 'should return unchanged Box object when Box object is provided', ->
      box_original = new DomBox.Box
      box_copy = new DomBox.getBox box_original
      expect(box_copy).toEqual box_original

      box_original = new DomBox.CollectionBox 'div'
      box_copy = new DomBox.getBox box_original
      expect(box_copy).toEqual box_original

      box_original = new DomBox.ElementBox document.createElement 'div'
      box_copy = new DomBox.getBox box_original
      expect(box_copy).toEqual box_original

    it 'should return collection Box when CSS selector is provided', ->
      box = DomBox.getBox 'div'
      expect(box instanceof DomBox.CollectionBox).toEqual true

    it 'should return element Box when element reference is provided', ->
      box = DomBox.getBox document.createElement 'div'
      expect(box instanceof DomBox.ElementBox).toEqual true

  describe 'box relations', ->

    afterEach ->
      for element in document.querySelectorAll '.aaa'
        element.parentNode.removeChild element

    describe 'get distance', ->

      it 'box inside another box', ->
        elm1 = createElement 0, 0, 200, 200
        elm2 = createElement 50, 50, 100, 100
        result = DomBox.getDistance elm1, elm2
        expect(result.horizontal).toEqual 0
        expect(result.vertical).toEqual 0

      it 'overlaping boxes', ->
        elm1 = createElement 0, 0, 100, 100
        elm2 = createElement 0, 0, 100, 100
        result = DomBox.getDistance elm1, elm2
        expect(result.horizontal).toEqual 0
        expect(result.vertical).toEqual 0

      it 'partialy overlaping boxes', ->
        elm1 = createElement 0, 0, 100, 100
        elm2 = createElement 50, 50, 100, 100
        result = DomBox.getDistance elm1, elm2
        expect(result.horizontal).toEqual 0
        expect(result.vertical).toEqual 0

      it 'boxes touching at side', ->
        elm1 = createElement 0, 0, 100, 100
        elm2 = createElement 0, 100, 100, 100
        result = DomBox.getDistance elm1, elm2
        expect(result.horizontal).toEqual 0
        expect(result.vertical).toEqual 0

      it 'boxes touching at corner', ->
        elm1 = createElement 0, 0, 100, 100
        elm2 = createElement 100, 100, 100, 100
        result = DomBox.getDistance elm1, elm2
        expect(result.horizontal).toEqual 0
        expect(result.vertical).toEqual 0

      it 'non-touching parallel boxes', ->
        elm1 = createElement 0, 0, 100, 100
        elm2 = createElement 0, 200, 100, 100
        result = DomBox.getDistance elm1, elm2
        expect(result.horizontal).toEqual 0
        expect(result.vertical).toEqual 100

      it 'non-touching boxes', ->
        elm1 = createElement 0, 0, 100, 100
        elm2 = createElement 200, 200, 100, 100
        result = DomBox.getDistance elm1, elm2
        expect(result.horizontal).toEqual 100
        expect(result.vertical).toEqual 100


    describe 'detectOverlap', ->

      it 'box inside another box', ->
        elm1 = createElement 0, 0, 200, 200
        elm2 = createElement 50, 50, 100, 100
        expect(DomBox.detectOverlap elm1, elm2).toEqual true

      it 'overlaping boxes', ->
        elm1 = createElement 0, 0, 100, 100
        elm2 = createElement 0, 0, 100, 100
        expect(DomBox.detectOverlap elm1, elm2).toEqual true

      it 'partialy overlaping boxes', ->
        elm1 = createElement 0, 0, 100, 100
        elm2 = createElement 50, 50, 100, 100
        expect(DomBox.detectOverlap elm1, elm2).toEqual true

      it 'boxes touching at side', ->
        elm1 = createElement 0, 0, 100, 100
        elm2 = createElement 0, 100, 100, 100
        expect(DomBox.detectOverlap elm1, elm2).toEqual false

      it 'boxes touching at corner', ->
        elm1 = createElement 0, 0, 100, 100
        elm2 = createElement 100, 100, 100, 100
        expect(DomBox.detectOverlap elm1, elm2).toEqual false

      it 'non-touching parallel boxes', ->
        elm1 = createElement 0, 0, 100, 100
        elm2 = createElement 0, 200, 100, 100
        expect(DomBox.detectOverlap elm1, elm2).toEqual false

      it 'non-touching boxes', ->
        elm1 = createElement 0, 0, 100, 100
        elm2 = createElement 200, 200, 100, 100
        expect(DomBox.detectOverlap elm1, elm2).toEqual false


    describe 'get pivot distance', ->

      it 'overlaping boxes', ->
        elm1 = createElement 0, 0, 100, 100
        elm2 = createElement 0, 0, 100, 100
        expect(DomBox.getPivotDistance elm1, elm2).toEqual 0

      it 'parallel boxes', ->
        elm1 = createElement 0, 0, 100, 100
        elm2 = createElement 0, 100, 100, 100
        expect(DomBox.getPivotDistance elm1, elm2).toEqual 100

      it 'boxes at angle', ->
        elm1 = createElement 0, 0, 100, 100
        elm2 = createElement 100, 100, 100, 100
        expect(DomBox.getPivotDistance elm1, elm2).toBeGreaterThan 141
        expect(DomBox.getPivotDistance elm1, elm2).toBeLessThan 142


    describe 'get angle between pivots', ->

      it 'overlaping boxes', ->
        elm1 = createElement 0, 0, 100, 100
        elm2 = createElement 0, 0, 100, 100
        expect(DomBox.getPivotAngle elm1, elm2).toEqual 0

      it 'parallel boxes', ->
        elm1 = createElement 0, 0, 100, 100
        elm2 = createElement 0, 100, 100, 100
        expect(DomBox.getPivotAngle elm1, elm2).toEqual 90

      it 'boxes at angle', ->
        elm1 = createElement 0, 0, 100, 100
        elm2 = createElement 100, 100, 100, 100
        expect(DomBox.getPivotAngle elm1, elm2).toEqual 45
