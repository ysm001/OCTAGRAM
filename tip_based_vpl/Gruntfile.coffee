module.exports = (grunt)->
  
  grunt.task.loadNpmTasks "grunt-contrib-concat"
  grunt.task.loadNpmTasks "grunt-contrib-coffee"
  grunt.task.loadNpmTasks "grunt-contrib-watch"
  grunt.task.loadNpmTasks "grunt-contrib-compass"
  grunt.task.loadNpmTasks "grunt-contrib-uglify"

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    watch:
      scripts:
        files: ["js/vpl/*.coffee"]
        tasks: ['coffee', 'concat']
        options:
          interrupt: yes
    coffee:
      compile:
        files: [
          expand: true
          cwd: './'
          src: [
            'js/vpl/*.coffee',
          ]
          dest: './'
          ext: '.js'
        ]
        options:
          bare: true
    concat:
        dist:
          src: [
            "js/vpl/storage.js",
            "js/vpl/event.js",
            "js/vpl/sprite-group.js",
            "js/vpl/tip-model.js",
            "js/vpl/tip-instruction.js",
            "js/vpl/test.js",
            "js/vpl/util.js",
            "js/vpl/resource.js",
            "js/vpl/tip-effect.js",
            "js/vpl/transition.js",
            "js/vpl/tip-view.js",
            "js/vpl/tip-icon.js",
            "js/vpl/tip-parameter.js",
            "js/vpl/tip-factory.js",
            "js/vpl/instruction-preset.js",
            "js/vpl/tip-instruction-stack.js",
            "js/vpl/tip-instruction-counter.js",
            "js/vpl/ui.js",
            "js/vpl/background.js",
            "js/vpl/cpu.js",
            "js/vpl/cpu-executer.js",
            "js/vpl/error-checker.js",
            "js/vpl/ui-slider.js",
            "js/vpl/ui-sidebar.js",
            "js/vpl/ui-config.js",
            "js/vpl/main.js"
          ]
          dest: "js/octagram.js"
    uglify:
      dist:
        src:'js/octagram.js'
        dest:'js/octagram.min.js'

  grunt.registerTask('default', ['watch', 'coffee', 'concat', 'uglify'])
