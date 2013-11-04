if !IS_MOBILE? then IS_MOBILE = false else Environment.Mobile = true

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

class Config.R
  @RESOURCE_DIR : "resources"
  @CHAR :
    PLAYER : "#{R.RESOURCE_DIR}/robot/player.png"
    ENEMY : "#{R.RESOURCE_DIR}/robot/enemy.png"
  @BACKGROUND_IMAGE :
    SPACE : "#{R.RESOURCE_DIR}/background/background_space.png"
    HEADER : "#{R.RESOURCE_DIR}/background/header.png"
    HP_RED : "#{R.RESOURCE_DIR}/background/hp_red.png"
    HP_GREEN : "#{R.RESOURCE_DIR}/background/hp_green.png"
    HP_ENCLOSE : "#{R.RESOURCE_DIR}/background/hpenclose.png"
    ENERGY : "#{R.RESOURCE_DIR}/background/energy.png"
    PLATE : "#{R.RESOURCE_DIR}/background/plate.png"
    MSGBOX : "#{R.RESOURCE_DIR}/background/msgbox.png"
    STATUS_BOX : "#{R.RESOURCE_DIR}/background/statusbox.png"
  @UI :
    FONT0 : "#{R.RESOURCE_DIR}/ui/font0.png"
    ICON0 : "#{R.RESOURCE_DIR}/ui/icon0.png"
    PAD : "#{R.RESOURCE_DIR}/ui/pad.png"
    APAD : "#{R.RESOURCE_DIR}/ui/apad.png"
  @EFFECT :
    EXPLOSION : "#{R.RESOURCE_DIR}/effect/explosion_64x64.png"
    SHOT : "#{R.RESOURCE_DIR}/effect/shot_player.png"
    SPOT_NORMAL : "#{R.RESOURCE_DIR}/effect/spot_normal.png"
    SPOT_WIDE : "#{R.RESOURCE_DIR}/effect/spot_wide.png"
    SPOT_DUAL : "#{R.RESOURCE_DIR}/effect/spot_dual.png"
    ENPOWER_NORMAL : "#{R.RESOURCE_DIR}/effect/enpower_normal.png"
    ENPOWER_WIDE : "#{R.RESOURCE_DIR}/effect/enpower_wide.png"
    ENPOWER_DUAL : "#{R.RESOURCE_DIR}/effect/enpower_dual.png"
  @BULLET :
    ENEMY : "#{R.RESOURCE_DIR}/bullet/bullet1.png"
    NORMAL : "#{R.RESOURCE_DIR}/bullet/normal.png"
    WIDE : "#{R.RESOURCE_DIR}/bullet/wide.png"
    DUAL : "#{R.RESOURCE_DIR}/bullet/dual.png"
  @ITEM :
    NORMAL_BULLET : "#{R.RESOURCE_DIR}/item/normal_bullet_item.png"
    WIDE_BULLET : "#{R.RESOURCE_DIR}/item/wide_bullet_item.png"
    DUAL_BULLET : "#{R.RESOURCE_DIR}/item/dual_bullet_item.png"
    STATUS_BULLET : "#{R.RESOURCE_DIR}/item/status_bullet.png"
  @TIP :
    ARROW : "#{R.RESOURCE_DIR}/tip/arrow.png"
    LIFE : "#{R.RESOURCE_DIR}/tip/life.png"
    PICKUP_BULLET : "#{R.RESOURCE_DIR}/tip/plus_bullet.png"
    SHOT_BULLET : "#{R.RESOURCE_DIR}/tip/shot_bullet.png"
    SEARCH_BARRIER : "#{R.RESOURCE_DIR}/tip/search_barrier.png"
    SEARCH_ENEMY : "#{R.RESOURCE_DIR}/tip/search_enemy.png"
    CURRENT_DIRECT : "#{R.RESOURCE_DIR}/tip/arrow.png"
    REST_BULLET : "#{R.RESOURCE_DIR}/tip/rest_bullet.png"

class Config.Frame
  @DIAMETER = 1

  @ROBOT_MOVE = 12 / Frame.DIAMETER
  @ROBOT_WAIT = 8 / Frame.DIAMETER
  @ROBOT_TURN = 8 / Frame.DIAMETER
  @BULLET = 16 / Frame.DIAMETER

class Config.Energy
  @MOVE     = 6
  @APPROACH = 8
  @LEAVE    = 8
  @SHOT     = 30
  @TURN     = 6

class Config.R.String
  @PLAYER : "プレイヤー"
  @ENEMY : "エネミー"
  @CANNOTMOVE : "移動てきません。"
  @CANNOTSHOT : "弾切れです。"
  @CANNOTPICKUP : "弾を補充できません。"

  @pickup: (s) -> "#{s}は弾を一つ補充しました。"
  @shot: (s) -> "#{s}は攻撃しました。"
  @move: (s, x, y) -> "#{s}は(#{x},#{y})に移動しました。"
  @die: (s) -> "#{s}はHPが0になりました。"
