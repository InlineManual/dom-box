module.exports = (config) ->

  config.set

    basePath: '..'
    # singleRun: true
    frameworks: ['jasmine']
    browsers: [
      'Chrome'
      # 'Firefox'
      # 'Safari'
      # 'Opera'
      # 'IE8 - WinXP'  # ievms
      # 'PhantomJS'
    ]
    files: [
      'test/css/style.css'
      'bower_components/angle-js/build/angle.js'
      'bower_components/isvisible/lib/isvisible.js'
      'build/dom-box.js'
      'test/spec/*.spec.js'
    ]
