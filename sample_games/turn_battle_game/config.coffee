        
class Config
    @GAME_WIDTH = 1280
    @GAME_HEIGHT = 640
    @GAME_OFFSET_X = 640
    @GAME_OFFSET_Y = 0

class Config.R
    @RESOURCE_DIR : "resources"
    @CHAR :
        PLAYER : "#{R.RESOURCE_DIR}/robot/player.png"
        ENEMY : "#{R.RESOURCE_DIR}/robot/enemy.png"
    @BACKGROUND_IMAGE :
        SPACE : "#{R.RESOURCE_DIR}/background/background_space.png"
        HEADER : "#{R.RESOURCE_DIR}/background/header.png"
        HP_YELLOW : "#{R.RESOURCE_DIR}/background/hp_yellow.png"
        HP_BULE : "#{R.RESOURCE_DIR}/background/hp_blue.png"
        HP_ENCLOSE : "#{R.RESOURCE_DIR}/background/hpenclose.png"
        PLATE : "#{R.RESOURCE_DIR}/background/plate.png"
        MSGBOX : "#{R.RESOURCE_DIR}/background/msgbox.png"
        STATUS_BOX : "#{R.RESOURCE_DIR}/background/statusbox.png"
        NEXT_BUTTON : "#{R.RESOURCE_DIR}/background/next_button.png"
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
        BARRIER_NORMAL :  "#{R.RESOURCE_DIR}/effect/barrier_normal.png"
        BARRIER_WIDE :  "#{R.RESOURCE_DIR}/effect/barrier_wide.png"
        BARRIER_DUAL :  "#{R.RESOURCE_DIR}/effect/barrier_dual.png"
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

    @INSTRUCTION :
        MOVE : 
            colnum : () -> "移動方向"
            label : [ 
                () -> "右"
                () -> "右上"
                () -> "右下"
                () -> "左"
                () -> "左上"
                () -> "左下"
            ]
            description : [
                (step) -> "右に#{step}マス移動します"
                (step) -> "右上に#{step}マス移動します"
                (step) -> "右下に#{step}マス移動します"
                (step) -> "左に#{step}マス移動します"
                (step) -> "左上に#{step}マス移動します"
                (step) -> "左下に#{step}マス移動します"
            ]
        SHOT : 
            colnum : () -> "弾の種類"
            label : [ 
                () -> "ストレート"
                () -> "ワイド"
                () -> "デュアル"
            ]
            description : [
                () -> "自機の前に2マス分弾を発射します"
                () -> "自機の右前と左前に1マス分弾を発射します"
                () -> "自機の前後に1マス分弾を発射します"
            ]
        PICKUP :
            colnum : () -> "弾の種類"
            label : [
                () -> "ストレート"
                () -> "ワイド"
                () -> "デュアル"
            ]
            description : [
                () -> "ストレートバレッドを拾います"
                () -> "ワイドバレッドを拾います"
                () -> "デュアルバレッドを拾います"
            ]
        HP :
            colnum : () -> "HP"
            description : (hp) -> "HPが#{hp}以上の時、青矢印に進みます。</ br>HPが#{hp}未満の時、赤矢印に進みます。"
        HOLD_BULLEFT :
            id : 
                kind : "kind"
                size : "size"
            colnum : (id) ->
                if id == "kind"
                    "弾の種類"
                else if id == "size"
                    "弾数"
            label : [
                () -> "ストレート"
                () -> "ワイド"
                () -> "デュアル"
            ]
            description : [
                (size) -> "ストレートバレッドの保持数が#{size}以上の時、青矢印に進みます。</br>ストレートバレッドの保持数が#{size}未満の時、赤矢印に進みます。"
                (size) -> "ワイドバレッドの保持数が#{size}以上の時、青矢印に進みます。</br>ワイドバレッドの保持数が#{size}未満の時、赤矢印に進みます。"
                (size) -> "デュアルバレッドの保持数が#{size}以上の時、青矢印に進みます。</br>デュアルバレッドの保持数が#{size}未満の時、赤矢印に進みます。"
            ]
