DomBox.Document =

  getWidth: ->
    Math.max(
      document.body?.scrollWidth
      document.body?.offsetWidth
      document.documentElement.clientWidth
      document.documentElement.scrollWidth
      document.documentElement.offsetWidth
      0
    )

  getHeight: ->
    Math.max(
      document.body.scrollHeight
      document.body.offsetHeight
      document.documentElement.clientHeight
      document.documentElement.scrollHeight
      document.documentElement.offsetHeight
      0
    )

  getSize: ->
    {
      width: DomBox.Document.getWidth()
      height: DomBox.Document.getHeight()
    }
