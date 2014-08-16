DomBox.Scroll =

  getLeft: ->
    (window.pageXOffset or html.scrollLeft) - (html.clientLeft or 0)

  getTop: ->
    (window.pageYOffset or html.scrollTop) - (html.clientTop or 0)

  getPosition: ->
    {
      left: DomBox.Scroll.getLeft()
      top: DomBox.Scroll.getTop()
    }
