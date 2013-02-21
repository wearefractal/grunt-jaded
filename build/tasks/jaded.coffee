path = require 'path'
jaded = require 'jaded'

module.exports = (grunt) ->
  grunt.registerMultiTask "jaded", "compile jade templates", ->
    for file in @files
      grunt.file.mkdir file.dest
      base = path.basename file.src, path.extname file.src
      dest = path.join file.dest, "#{base}.js"
      # for includes
      @data.options['filename'] = file.src
      templ = jaded.compile grunt.file.read(file.src), @data.options
      grunt.file.write dest, templ