DomBox.Document =

  getWidth: ->
    Math.max(
      body.scrollWidth
      body.offsetWidth
      html.clientWidth
      html.scrollWidth
      html.offsetWidth
    )

  getHeight: ->
    Math.max(
      body.scrollHeight
      body.offsetHeight
      html.clientHeight
      html.scrollHeight
      html.offsetHeight
    )

  getSize: ->
    {
      width: DomBox.Document.getWidth()
      height: DomBox.Document.getHeight()
    }
