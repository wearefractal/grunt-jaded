coffee     = require 'coffee-script'
Mocha      = require 'mocha'
root       = require('path').join __dirname, "../"

gruntConfig =
  pkg: "<json:package.json>"
  test:
    files: ["./test/*.coffee"]
  mocha: 
    options: 
      reporter:    'spec'
      ui:          'exports'
      ignoreLeaks: 'true'
  jaded:
    app:
      src: [ "#{root}/test/views/**/*.jade" ]
      dest:  "#{root}/test/public/templates"
      options:
        amd: true
        development: false
        rivets: false
  #watch:
    #test:
    #  files: "<config:test.files>"
    #  tasks: "test"
  globals:
    exports: true

module.exports = (grunt) ->

  ## init config  
  grunt.initConfig gruntConfig
  grunt.loadTasks 'tasks'

  ## default 
  grunt.registerTask "default", "jaded test"

  ## grunt-mocha-node
  grunt.registerMultiTask "test", "Run unit tests with Mocha", ->
    # tell grunt this is an asynchronous task
    done = @async()

    for key of require.cache
      if require.cache[key]
        delete require.cache[key]

        console.warn "Mocha grunt task: Could not delete from require cache:\n" + key  if require.cache[key]
      else
        console.warn "Mocha grunt task: Could not find key in require cache:\n" + key

    # load the options if they are specified
    if typeof options is 'object'
      options = grunt.config(["mocha", @target, "options"])
    else
      options = grunt.config("mocha.options") 
    
    # create a mocha instance with our options
    mocha = new Mocha(options)

    # add files to mocha
    for file in grunt.file.expandFiles(@file.src)
      mocha.addFile file

    # run mocha asynchronously and catch errors!! (again, in case we are running this task in watch)

    try
      mocha.run (failureCount) ->
        console.log "Mocha completed with " + failureCount + " failing tests"
        done failureCount is 0
    catch e
      console.log "Mocha exploded!"
      console.log e.stack
      done false
