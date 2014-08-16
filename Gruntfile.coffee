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
            'src/coffee/scroll.coffee'
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
          'build/<%= pkg.name %>.min.js' : 'build/<%= pkg.name %>.js'

    watch:
      default:
        options:
          atBegin: true
        files: [
          'src/coffee/**/*.coffee'
          'test/src/**/*.coffee'
        ]
        tasks: ['coffeelint', 'coffee', 'jasmine']

    bump:
      options:
        files: [
          'package.json'
          'bower.json'
        ]
        updateConfigs: ['pkg']
        commitFiles: ['-a']
        push: false

  grunt.registerTask 'build', [
    'coffeelint'
    'coffee'
    'jasmine'
    'uglify'
  ]

  grunt.registerTask 'default', [
    'watch'
  ]
