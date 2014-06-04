module.exports = (grunt) ->

  require('load-grunt-tasks')(grunt);

  grunt.initConfig

    pkg: grunt.file.readJSON 'package.json'

    coffeelint:
      src: 'src/coffee/*.coffee'
      test: 'test/src/*.coffee'

    jasmine:
      default:
        src: ['build/*.js', '!build/*.min.js']
        options:
          keepRunner: false
          specs: 'test/spec/<%= pkg.name %>.spec.js'

    coffee:
      src:
        files:
          'build/<%= pkg.name %>.js' : 'src/coffee/*.coffee'
      test:
        files:
          'test/spec/<%= pkg.name %>.spec.js' : 'test/src/*.coffee'

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
      options:
        atBegin: true
      src:
        files: ['src/coffee/*.coffee']
        tasks: ['coffeelint:src', 'coffee:src', 'jasmine']
      test:
        files: ['test/src/*.coffee']
        tasks: ['coffeelint:test', 'coffee:test', 'jasmine']





  grunt.registerTask 'build', [
    'coffeelint'
    'coffee'
    'jasmine'
    'uglify'

  ]

  grunt.registerTask 'default', [
    'watch'
  ]
