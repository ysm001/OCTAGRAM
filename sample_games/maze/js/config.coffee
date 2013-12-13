if !IS_MOBILE? then IS_MOBILE = false else Environment.Mobile = true

SPEED = 2

(() ->
  classes = [ enchant.model.SpriteModel, enchant.model.GroupModel ]
  for cls in classes
    cls.prototype.__constructor = cls.prototype.constructor
    cls.prototype.constructor = () ->
      @properties ?= {}
      Object.defineProperties this, @properties
      @__constructor.apply(this, arguments)
)()

class Config
  @GAME_WIDTH = 640
  @GAME_HEIGHT = 640
  @GAME_OFFSET_X = 0
  @GAME_OFFSET_Y = 0
  @IS_MOBILE : IS_MOBILE

  @EDITOR_MOBILE_SCALE_X = 0.2
  @EDITOR_MOBILE_SCALE_Y = 0.2
  @EDITOR_MOBILE_OFFSET_X = 640 - 128
  @EDITOR_MOBILE_OFFSET_Y = 640 - 128

  @OCTAGRAM_DIR : if (UserConfig?) then UserConfig.OCTAGRAM_DIR else "./js/octagram"

class Config.R
  @RESOURCE_DIR : if (UserConfig? && UserConfig.R?) then UserConfig.R.RESOURCE_DIR  else "resources"
  @MAP :
    SRC : "#{R.RESOURCE_DIR}/map0.png"
    BACKGROUND1 : "#{R.RESOURCE_DIR}/map/background-1.png"
    BACKGROUND_TRANSPARENT : "#{R.RESOURCE_DIR}/map/background-transparent.png"
    BACKGROUND_MERGED : "#{R.RESOURCE_DIR}/map/background-merged.png"
    BACKGROUND_EFFECT : "#{R.RESOURCE_DIR}/map/background-effect.png"
    START : "#{R.RESOURCE_DIR}/map/start.png"
    GOAL : "#{R.RESOURCE_DIR}/map/goal.png"
    ROAD  : "#{R.RESOURCE_DIR}/map/road.png"
    WALL1_1 : "#{R.RESOURCE_DIR}/map/wall1-1.png"
    WALL1_2 : "#{R.RESOURCE_DIR}/map/wall1-2.png"
    WALL1_3 : "#{R.RESOURCE_DIR}/map/wall1-3.png"
    WALL1_4 : "#{R.RESOURCE_DIR}/map/wall1-4.png"
    WALL2_1 : "#{R.RESOURCE_DIR}/map/wall2-1.png"
    WALL2_2 : "#{R.RESOURCE_DIR}/map/wall2-2.png"
    WALL3_TOP    : "#{R.RESOURCE_DIR}/map/wall3-1.png"
    WALL3_RIGHT  : "#{R.RESOURCE_DIR}/map/wall3-2.png"
    WALL3_BOTTOM : "#{R.RESOURCE_DIR}/map/wall3-3.png"
    WALL3_LEFT   : "#{R.RESOURCE_DIR}/map/wall3-4.png"
    WALL4 : "#{R.RESOURCE_DIR}/map/wall4.png"
    WALL5 : "#{R.RESOURCE_DIR}/map/wall5.png"
    WALL6_1 : "#{R.RESOURCE_DIR}/map/wall6-1.png"
    WALL6_2 : "#{R.RESOURCE_DIR}/map/wall6-2.png"
    WALL6_3 : "#{R.RESOURCE_DIR}/map/wall6-3.png"
    WALL6_4 : "#{R.RESOURCE_DIR}/map/wall6-4.png"
    WALL7_1 : "#{R.RESOURCE_DIR}/map/wall7-1.png"
    WALL7_2 : "#{R.RESOURCE_DIR}/map/wall7-2.png"
    WALL7_3 : "#{R.RESOURCE_DIR}/map/wall7-3.png"
    WALL7_4 : "#{R.RESOURCE_DIR}/map/wall7-4.png"
    WALL8_1 : "#{R.RESOURCE_DIR}/map/wall8-1.png"
    WALL8_2 : "#{R.RESOURCE_DIR}/map/wall8-2.png"
    WALL8_3 : "#{R.RESOURCE_DIR}/map/wall8-3.png"
    WALL8_4 : "#{R.RESOURCE_DIR}/map/wall8-4.png"
    WALL9 : "#{R.RESOURCE_DIR}/map/wall9.png"
    WALL10_1 : "#{R.RESOURCE_DIR}/map/wall10-1.png"
    WALL10_2 : "#{R.RESOURCE_DIR}/map/wall10-2.png"
    WALL10_3 : "#{R.RESOURCE_DIR}/map/wall10-3.png"
    WALL10_4 : "#{R.RESOURCE_DIR}/map/wall10-4.png"
  @CHAR :
    CHAR0 : "#{R.RESOURCE_DIR}/chara0.png"
    CHAR1 : "#{R.RESOURCE_DIR}/chara1.png"
  @TIP :
    ARROW : "#{R.RESOURCE_DIR}/tip/arrow.png"
    LIFE : "#{R.RESOURCE_DIR}/tip/life.png"
    PICKUP_BULLET : "#{R.RESOURCE_DIR}/tip/plus_bullet.png"
    SHOT_BULLET : "#{R.RESOURCE_DIR}/tip/shot_bullet.png"
    SEARCH_BARRIER : "#{R.RESOURCE_DIR}/tip/search_barrier.png"
    SEARCH_ENEMY : "#{R.RESOURCE_DIR}/tip/search_enemy.png"
    CURRENT_DIRECT : "#{R.RESOURCE_DIR}/tip/arrow.png"
    REST_BULLET : "#{R.RESOURCE_DIR}/tip/rest_bullet.png"
    RANDOM_MOVE : "#{R.RESOURCE_DIR}/tip/random_move.png"
    MOVE_TO_ENEMY : "#{R.RESOURCE_DIR}/tip/move_to_enemy.png"
    MOVE_FROM_ENEMY : "#{R.RESOURCE_DIR}/tip/move_from_enemy.png"
    ENERGY : "#{R.RESOURCE_DIR}/tip/energy.png"
    REST_ENERGY_PLAYER : "#{R.RESOURCE_DIR}/tip/rest_energy_player.png"
    REST_ENERGY_ENEMY : "#{R.RESOURCE_DIR}/tip/rest_energy_enemy.png"
    DISTANCE : "#{R.RESOURCE_DIR}/tip/distance.png"
  @EFFECT :
    SEARCH : "#{R.RESOURCE_DIR}/effect/antena_anim.png"




