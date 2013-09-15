module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-simple-mocha'
  grunt.loadNpmTasks 'grunt-release'

  grunt.initConfig
    simplemocha:
      options:
        reporter: 'spec'
        compilers: 'coffee:coffee-script'
      all: {src: 'test/*'}

    coffee:
      compile:
        files: {'index.js': 'index.coffee'}

  grunt.registerTask 'default', ['coffee', 'simplemocha']
