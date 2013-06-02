        
class Config
    @GAME_WIDTH = 640
    @GAME_HEIGHT = 640


class Config.R
    @RESOURCE_DIR : "resources"
    @CHAR :
        PLAYER : "#{R.RESOURCE_DIR}/robot/player.png"
        ENEMY : "#{R.RESOURCE_DIR}/robot/enemy.png"
    @BACKGROUND_IMAGE :
        SPACE : "#{R.RESOURCE_DIR}/background/statespace.png"
        HEADER : "#{R.RESOURCE_DIR}/background/header.png"
        HP_YELLOW : "#{R.RESOURCE_DIR}/background/hp_yellow.png"
        HP_BULE : "#{R.RESOURCE_DIR}/background/hp_blue.png"
        HEADER_UNDER_BAR : "#{R.RESOURCE_DIR}/background/hp_under_bar.png"
        TILE : "#{R.RESOURCE_DIR}/background/tile.png"
        MSGBOX : "#{R.RESOURCE_DIR}/background/msgbox.png"
        STATUS_BOX : "#{R.RESOURCE_DIR}/background/status_box.png"
        NEXT_BUTTON : "#{R.RESOURCE_DIR}/background/next_button.png"
    @UI :
        FONT0 : "#{R.RESOURCE_DIR}/ui/font0.png"
        ICON0 : "#{R.RESOURCE_DIR}/ui/icon0.png"
        PAD : "#{R.RESOURCE_DIR}/ui/pad.png"
        APAD : "#{R.RESOURCE_DIR}/ui/apad.png"
    @EFFECT :
        EXPLOSION : "#{R.RESOURCE_DIR}/effect/explosion_64x64.png"
    @BULLET :
        ENEMY : "#{R.RESOURCE_DIR}/bullet/bullet1.png"
        DROID : "#{R.RESOURCE_DIR}/bullet/bullet2.png"

        #enchant.ui = { assets: [Config.R.PAD, Config.R.APAD, Config.R.FONT0, Config.R.ICON0] }
class Config.R.String
    
    @PLAYER : "プレイヤー"
    @ENEMY : "エネミー"
    @CANNOTMOVE : "移動てきません"
    @CANNOTSHOT : "弾切れです"
    @CANNOTPICKUP : "弾を補充できません"

    @pickup:(s) ->
        return "#{s}は弾を一つ補充しました"
    @shot:(s) ->
        return "#{s}は攻撃しました"
    @move:(s, x, y) ->
        return "#{s}は(#{x},#{y})に移動しました"
enchant()
enchant.ui = { assets: ['resources/ui/pad.png', 'resources/ui/apad.png', 'resources/ui/icon0.png', 'resources/ui/font0.png'] }
