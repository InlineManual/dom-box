describe 'Box', ->

  box = null

  beforeEach ->
    box = new DomBox.Box
    box.width       =  100
    box.height      =  200
    box.left        =  300
    box.top         =  400
    box.right       =  500
    box.bottom      =  600
    box.view_left   =  700
    box.view_top    =  800
    box.view_right  =  900
    box.view_bottom = 1000

  it 'should be created with default properties', ->
    box = new DomBox.Box
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

  it 'should get pivot', ->
    pivot = box.getPivot()
    expect(pivot.left).toEqual 350
    expect(pivot.top).toEqual 500

  it 'should add padding', ->
    padded_box = box.pad 50
    expect(box.width       ).toEqual  200
    expect(box.height      ).toEqual  300
    expect(box.left        ).toEqual  250
    expect(box.top         ).toEqual  350
    expect(box.right       ).toEqual  550
    expect(box.bottom      ).toEqual  650
    expect(box.view_left   ).toEqual  650
    expect(box.view_top    ).toEqual  750
    expect(box.view_right  ).toEqual  950
    expect(box.view_bottom ).toEqual 1050

  it 'should have default padding', ->
    expect(box.padding).toBeDefined()

  it 'should set default padding', ->
    box.setPadding 100
    expect(box.padding).toEqual 100

  it 'should update when padding is set', ->
    spyOn box, 'update'
    box.setPadding 100
    expect(box.update).toHaveBeenCalled()

  it 'should apply default padding on every update', ->
    box.setPadding 100
    spyOn box, 'pad'
    box.update()
    expect(box.pad).toHaveBeenCalledWith 100
