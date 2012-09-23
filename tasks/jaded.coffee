module.exports = (grunt) ->
  grunt.registerMultiTask "jaded", "compile jaded templates", ->
    jaded = require 'jaded'
    files = grunt.file.expandFiles @file.src
    grunt.file.mkdir @file.dest
    for file in files
      base = path.basename file, path.extname file
      dest = path.join @file.dest, "#{base}.js"
      templ = jaded.compile grunt.file.read(file), @data.options
      grunt.file.write dest, templ