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
            'js/*.coffee',
          ]
          dest: './'
          ext: '.js'
        ]
        options:
          bare: true
    concat:
        dist:
          src: [
            "js/third_party/mt.js",
            "js/config.js",
            "js/utility/util.js",
            "js/utility/debug.js",
            "js/effect.js",
            "js/bullet.js",
            "js/item.js",
            "js/robot.js",
            "js/octagram_instruction/common.js",
            "js/octagram_instruction/approach-instruction.js",
            "js/octagram_instruction/leave-instruction.js",
            "js/octagram_instruction/move-instruction.js"
            "js/octagram_instruction/random-move-instruction.js"
            "js/octagram_instruction/shot-instruction.js",
            "js/octagram_instruction/supply-instruction.js",
            "js/octagram_instruction/turn-enemy-scan-instruction.js",
            "js/octagram_instruction/energy-branch-instruction.js",
            "js/octagram_instruction/enemy-energy-branch-instruction.js",
            "js/octagram_instruction/enemy-distance-instruction.js",
            "js/octagram_instruction/hp-branch-instruction.js",
            "js/octagram_instruction/resource-branch-instruction.js",
            "js/view/view.js",
            "js/view/header/hp-view.js",
            "js/view/header/energy-view.js",
            "js/view/header/header-view.js",
            "js/view/header/timer-view.js",
            "js/view/content/content-view.js",
            "js/view/footer/footer-view.js",
            "js/main.js"
          ]
          dest: "code-combat.js"
    uglify:
      dist:
        src:'code-combat.js'
        dest:'code-combat.min.js'

  grunt.registerTask('default', ['watch', 'coffee', 'concat', 'uglify'])
  grunt.registerTask 'build', 'build task.', () ->
    grunt.task.run('coffee', 'concat', 'uglify')
