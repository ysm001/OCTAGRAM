if !IS_MOBILE? then IS_MOBILE = false else Environment.Mobile = true

class RobotAIGame
  @END :
    KILL   : 1
    TIMERT : 2

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
  @CHAR :
    PLAYER : "#{R.RESOURCE_DIR}/robot/player.png"
    ENEMY : "#{R.RESOURCE_DIR}/robot/enemy.png"
  @BACKGROUND_IMAGE :
    SPACE : "#{R.RESOURCE_DIR}/background/background_space.png"
    HEADER : "#{R.RESOURCE_DIR}/background/header.png"
    HP_RED : "#{R.RESOURCE_DIR}/background/hp_red.png"
    HP_GREEN : "#{R.RESOURCE_DIR}/background/hp_green.png"
    TIMER : "#{R.RESOURCE_DIR}/background/timer.png"
    HP_ENCLOSE : "#{R.RESOURCE_DIR}/background/hpenclose.png"
    ENERGY : "#{R.RESOURCE_DIR}/background/energy.png"
    PLATE : "#{R.RESOURCE_DIR}/background/plate.png"
    PLATE_OVERLAY : "#{R.RESOURCE_DIR}/background/plate_overlay.png"
    PLATE_ENERGY : "#{R.RESOURCE_DIR}/background/plate_energy.png"
    MSGBOX : "#{R.RESOURCE_DIR}/background/msgbox.png"
    #STATUS_BOX : "#{R.RESOURCE_DIR}/background/statusbox.png"
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

  setAllFrame = () ->
    Frame.ROBOT_MOVE                    =  12 / Frame.DIAMETER
    Frame.ROBOT_HIGH_SEEPD_MOVE         =   8 / Frame.DIAMETER
    Frame.ROBOT_WAIT                    =   8 / Frame.DIAMETER
    Frame.ROBOT_TURN                    =   8 / Frame.DIAMETER
    Frame.ROBOT_SUPPLY                  =  80 / Frame.DIAMETER
    Frame.BULLET                        =  20 / Frame.DIAMETER
    Frame.NATURAL_MAP_ENERGY_RECAVERY   = 100 / Frame.DIAMETER
    Frame.NATURAL_ROBOT_ENERGY_RECAVERY = 192 / Frame.DIAMETER
    Frame.GAME_TIMER_CLOCK              =  28 / Frame.DIAMETER
  setAllFrame()

  @setGameSpeed: (diameter = 1) ->
    if 0 < diameter <= 4 and diameter % 2 == 0
      Config.Frame.DIAMETER = diameter
    if diameter == 1
      Config.Frame.DIAMETER = 1
    setAllFrame()
    diameter

class Config.Energy
  @MOVE                =  8
  @HIGH_SEEPD_MOVE     = 14
  @APPROACH            = 10
  @LEAVE               = 10
  @SHOT                = 45
  @TURN                =  8

class Config.R.String
  @PLAYER : "プレイヤー"
  @ENEMY : "エネミー"
  @CANNOTMOVE : "移動できません。"
  @CANNOTSHOT : "弾切れです。"
  @CANNOTPICKUP : "弾を補充できません。"

  @pickup: (s) -> "#{s}は弾を一つ補充しました。"
  @shot: (s) -> "#{s}は攻撃しました。"
  @turn: (s) -> "#{s}は敵をサーチしています。"
  @move: (s, x, y) -> "#{s}は(#{x},#{y})に移動しました。"
  @supply: (s, e) -> "#{s}は#{e}エネルギー補給しました。"
  @state: (h, e) -> "(HP: #{h}, エネルギー: #{e})"
  @die: (s) -> "#{s}はHPが0になりました。"
  @timelimit: (s) -> "タイムアップで#{s}は判定負けとなります。"
  @win: (s) -> "#{s}の勝利になります。"
