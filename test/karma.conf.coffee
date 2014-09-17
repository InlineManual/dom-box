module.exports = (config) ->

  config.set

    # TODO move these to env variables
    browserStack:
      username: 'mareksotak'
      accessKey: 'RMhwisXwMVXzR7qBkg8q'

    customLaunchers:

      bs_ie:
        base: 'BrowserStack'
        browser: 'ie'
        browser_version: 'latest'
        os: 'Windows'
        os_version: '8'

      bs_ie8:
        base: 'BrowserStack'
        browser: 'ie'
        browser_version: '8'
        os: 'Windows'
        os_version: 'XP'
        'x-ua-compatible': 'IE=Edge'

    basePath: '..'
    # singleRun: true
    frameworks: ['jasmine']
    browsers: [
      'Chrome'
      # 'Firefox'
      # 'Safari'
      # 'Opera'
      # 'IE8 - WinXP'  # ievms
      # 'bs_ie'      # browser stack
      # 'bs_ie8'     # browser stack
    ]
    files: [
      'build/dom-box.js'
      'test/spec/*.spec.js'
    ]


    # to avoid DISCONNECTED messages when connecting to BrowserStack
    # browserDisconnectTimeout : 10000      # default 2000
    # browserDisconnectTolerance : 1        # default 0
    # browserNoActivityTimeout : 4*60*1000  # default 10000
    # captureTimeout : 4*60*1000            # default 60000
