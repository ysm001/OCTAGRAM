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
  @CHAR :
    CHAR1 : "#{R.RESOURCE_DIR}/chara0.png"
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

 


