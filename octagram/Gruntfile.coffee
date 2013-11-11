module.exports = (grunt)->
  
  grunt.task.loadNpmTasks "grunt-contrib-concat"
  grunt.task.loadNpmTasks "grunt-contrib-coffee"
  grunt.task.loadNpmTasks "grunt-contrib-watch"
  grunt.task.loadNpmTasks "grunt-contrib-compass"
  grunt.task.loadNpmTasks "grunt-contrib-uglify"

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    all:
      tasks: ['coffee', 'concat', 'uglify']
      options:
        interrupt: yes
    watch:
      scripts:
        files: ["js/*.coffee"]
        tasks: ['coffee', 'concat', 'uglify']
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
            "js/octagram-init.js",
            "js/core/util/storage.js",
            "js/core/event/event.js",
            "js/core/ui/sprite-group.js",
            "js/core/effect.js",
            "js/core/tip/tip-model.js",
            "js/core/util/util.js",
            "js/core/resource.js",
            "js/core/tip/tip-effect.js",
            "js/core/tip/transition.js",
            "js/core/tip/tip-view.js",
            "js/core/tip/tip-factory.js",
            "js/core/tip/instruction/instruction-preset.js",
            "js/core/tip/instruction/tip-instruction-stack.js",
            "js/core/tip/instruction/tip-instruction-counter.js",
            "js/core/tip/instruction/custom-instruction-tip.js",
            "js/core/ui/background.js",
            "js/core/cpu/cpu.js",
            "js/core/cpu/cpu-executer.js",
            "js/core/ui/slider.js",
            "js/core/ui/sidebar.js",
            "js/core/ui/config-panel.js",
            "js/core/ui/ui.js",
            "js/core/ui/direction-selector.js",
            "js/core/environment.js",
            "js/core/octagram-content.js",
            "js/core/octagram-core.js",
          ]
          dest: "js/octagram.js"
    uglify:
      dist:
        src:'js/octagram.js'
        dest:'js/octagram.min.js'

  grunt.registerTask('default', ['watch', 'coffee', 'concat', 'uglify'])
  grunt.registerTask 'build', 'build task.', () ->
    grunt.task.run('coffee', 'concat', 'uglify')
