createElement = (left = 0, top = 0, width = 100, height = 100) ->
  elm = document.createElement 'div'
  elm.style.position = 'absolute'
  elm.style.top = "#{top}px"
  elm.style.left = "#{left}px"
  elm.style.width = "#{width}px"
  elm.style.height = "#{height}px"
  elm.className = 'aaa'
  document.body.appendChild elm

describe 'getExtremes', ->

  it 'should return extremes of array of boxes', ->
    box1 =
      left: 100, top: 100, right: 200, bottom: 200
      view_left: 100, view_top: 100, view_right: 200, view_bottom: 200
    box2 =
      left: 300, top: 300, right: 400, bottom: 400
      view_left: 300, view_top: 300, view_right: 400, view_bottom: 400
    expectation =
      left: 100, top: 100, right: 400, bottom: 400
      view_left: 100, view_top: 100, view_right: 400, view_bottom: 400
      width: 300, height: 300
    extremes = getExtremes [box1, box2]
    expect(extremes).toEqual expectation
