if !IS_MOBILE? then IS_MOBILE = false else Environment.Mobile = true

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
    WALL6 : "#{R.RESOURCE_DIR}/map/wall6.png"
    WALL7 : "#{R.RESOURCE_DIR}/map/wall7.png"
    WALL8_1 : "#{R.RESOURCE_DIR}/map/wall8-1.png"
    WALL8_2 : "#{R.RESOURCE_DIR}/map/wall8-2.png"
    WALL8_3 : "#{R.RESOURCE_DIR}/map/wall8-3.png"
    WALL8_4 : "#{R.RESOURCE_DIR}/map/wall8-4.png"
    WALL9 : "#{R.RESOURCE_DIR}/map/wall9.png"
  @CHAR :
    CHAR0 : "#{R.RESOURCE_DIR}/chara0.png"
    CHAR1 : "#{R.RESOURCE_DIR}/chara1.jpg"
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




