module.exports = (config) ->

  config.set

    basePath: '..'
    # singleRun: true
    frameworks: ['jasmine']
    browsers: [
      'Chrome'
      'Firefox'
      'Safari'
      'Opera'
      # 'IE8 - WinXP'  # ievms
    ]
    files: [
      'build/dom-box.js'
      'test/spec/*.spec.js'
    ]
