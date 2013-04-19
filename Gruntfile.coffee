module.exports = (grunt) ->

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-copy'

  grunt.initConfig
    coffee:
      options:
        sourceMap: true
      files:
        expand: true
        src: ['**/*.coffee', '!**/build/**', '!**/node_modules/**']
        dest: 'build/'
        ext: '.js'
    copy:
      main:
        files: [
          expand: true
          src: ['**/*.*', '!*.coffee', '!**/node_modules/**']
          dest: 'build/'
        ]
