path = require 'path'
jaded = require 'jaded'

module.exports = (grunt) ->
  grunt.registerMultiTask "jaded", "compile jade templates", ->
    for file in @files
      base = path.basename file.src, path.extname file.src
      basedir = path.dirname file.dest
      dest = path.join basedir, "#{base}.js"
      grunt.file.mkdir basedir
      # for includes
      @data.options.filename = file.src
      templ = jaded.compile grunt.file.read(file.src), @data.options
      grunt.file.write dest, templ