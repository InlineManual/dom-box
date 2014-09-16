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

    basePath: '..'
    # singleRun: true
    frameworks: ['jasmine']
    browsers: [
      'Chrome'
      'Firefox'
      'bs_ie'
      'bs_ie8'
    ]
    files: [
      'build/dom-box.js'
      'test/spec/*.spec.js'
    ]
