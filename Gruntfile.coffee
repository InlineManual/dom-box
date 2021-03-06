module.exports = (grunt) ->

  require('load-grunt-tasks')(grunt)

  grunt.initConfig

    pkg: grunt.file.readJSON 'package.json'

    coffeelint:
      src: 'src/coffee/*.coffee'
      test: 'test/src/*.coffee'

    jasmine:
      options:
        summary: true
      utilities:
        src: ['test/utilities/**/*.js']
        options:
          keepRunner: true
          outfile: 'test/runner/utilities.html'
          specs: 'test/spec/utilities/**/*.spec.js'
      default:
        src: ['build/*.js', '!build/*.min.js']
        options:
          keepRunner: true
          outfile: 'test/runner/<%= pkg.name %>.html'
          specs: 'test/spec/*.spec.js'
          page:
            viewportSize:
              width: 1000
              height: 1000

    karma:
      default:
        configFile: 'test/karma.conf.coffee'

    coffee:
      src:
        options:
          join: true
        files:
          'build/<%= pkg.name %>.js': [
            'src/coffee/utilities/*.coffee'
            'src/coffee/dom-box.coffee'
            'src/coffee/box.coffee'
            'src/coffee/element-box.coffee'
            'src/coffee/collection-box.coffee'
            'src/coffee/document.coffee'
            'src/coffee/viewport.coffee'
          ]
      utilities:
        options:
          bare: true
        expand: true
        flatten: false
        cwd: 'src/coffee/utilities'
        src: ['**/*.coffee']
        dest: 'test/utilities'
        ext: '.js'
      test:
        expand: true
        flatten: false
        cwd: 'test/src'
        src: ['**/*.spec.coffee']
        dest: 'test/spec'
        ext: '.spec.js'

    uglify:
      default:
        options:
          banner:
            """
              // <%= pkg.title %>, v<%= pkg.version %>
              // by <%= pkg.author %>
              // <%= pkg.homepage %>

            """
        files:
          'build/<%= pkg.name %>.min.js': [
            'bower_components/isvisible/lib/isvisible.js'
            'bower_components/angle-js/build/angle.js'
            'build/<%= pkg.name %>.js'
          ]

    watch:
      default:
        options:
          atBegin: true
        files: [
          'src/coffee/**/*.coffee'
          'test/src/**/*.coffee'
        ]
        tasks: [
          'coffeelint'
          'coffee'
          # 'jasmine'
        ]

    bump:
      options:
        files: ['package.json', 'bower.json']
        updateConfigs: ['pkg']
        commitFiles: ['-a']
        pushTo: 'origin'

    concurrent:
      default:
        tasks: [
          'karma'
          'watch'
        ]
        options:
          logConcurrentOutput: true


  # Constructs the code, runs tests and if everyting is OK, creates a minified
  # version ready for production. This task is intended to be run manually.
  grunt.registerTask 'build', 'Bumps version and builds JS.', (version_type) ->
    version_type = 'patch' unless version_type in ['patch', 'minor', 'major']
    grunt.task.run [
      "bump-only:#{version_type}"
      'coffeelint'
      'coffee'
      'uglify'
      'bump-commit'
    ]


  grunt.registerTask 'default', [
    'concurrent'
  ]
