        
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
        STATUS_BARRIER : "#{R.RESOURCE_DIR}/item/status_barrier.png"
    @TIP :
        ARROW : "#{R.RESOURCE_DIR}/tip/arrow.png"
        LIFE : "#{R.RESOURCE_DIR}/tip/arrow.png"
        PICKUP_BULLET : "#{R.RESOURCE_DIR}/tip/plus_bullet.png"
        SHOT_BULLET : "#{R.RESOURCE_DIR}/tip/shot_bullet.png"
        SEARCH_BARRIER : "#{R.RESOURCE_DIR}/tip/search_barrier.png"
        SEARCH_ENEMY : "#{R.RESOURCE_DIR}/tip/search_enemy.png"
        CURRENT_DIRECT : "#{R.RESOURCE_DIR}/tip/arrow.png"
        REST_BULLET : "#{R.RESOURCE_DIR}/tip/rest_bullet.png"

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
        Move : 
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
        Shot : 
            colnum : () -> "弾の種類"
            label : [ 
                () -> "ストレート"
                () -> "ワイド"
                () -> "デュアル"
            ]
            description : [
                () -> "自機の前に4マス分弾を発射します"
                () -> "自機の右前と左前に2マス分弾を発射します"
                () -> "自機の前後に2マス分弾を発射します"
            ]
        Pickup :
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
        Hp :
            colnum : () -> "HP"
            description : (hp) -> "HPが#{hp}以上の時、青矢印に進みます。</ br>HPが#{hp}未満の時、赤矢印に進みます。"
        HoldBulleft :
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
        SearchingRobotDirect :
            id : 
                direct : "direct"
                lenght : "lenght"
            colnum : (id) ->
                switch id
                    when "direct"
                        "方向"
                    when "lenght"
                        "距離"
            label : [
                () -> "右"
                () -> "右上"
                () -> "右下"
                () -> "左"
                () -> "左上"
                () -> "左下"
            ]
            description : [
                (step) -> "右に#{step}マス索敵を行い敵が見つかった場合、青矢印に進みます。</br>見つからなかった場合、赤矢印に進みます。"
                (step) -> "右上に#{step}マス索敵を行い敵が見つかった場合、青矢印に進みます。</br>見つからなかった場合、赤矢印に進みます。"
                (step) -> "右下に#{step}マス索敵を行い敵が見つかった場合、青矢印に進みます。</br>見つからなかった場合、赤矢印に進みます。"
                (step) -> "左に#{step}マス索敵を行い敵が見つかった場合、青矢印に進みます。</br>見つからなかった場合、赤矢印に進みます。"
                (step) -> "左上に#{step}マス索敵を行い敵が見つかった場合、青矢印に進みます。</br>見つからなかった場合、赤矢印に進みます。"
                (step) -> "左下に#{step}マス索敵を行い敵が見つかった場合、青矢印に進みます。</br>見つからなかった場合、赤矢印に進みます。"
            ]
        SearchingItemDirect :
            id : 
                direct : "direct"
                lenght : "lenght"
            colnum : (id) ->
                switch id
                    when "direct"
                        "方向"
                    when "lenght"
                        "距離"
            label : [
                () -> "右"
                () -> "右上"
                () -> "右下"
                () -> "左"
                () -> "左上"
                () -> "左下"
            ]
            description : [
                (step) -> "右に#{step}マス索敵を行いバリアアイテムが見つかった場合、青矢印に進みます。</br>見つからなかった場合、赤矢印に進みます。"
                (step) -> "右上に#{step}マス索敵を行いバリアアイテムが見つかった場合、青矢印に進みます。</br>見つからなかった場合、赤矢印に進みます。"
                (step) -> "右下に#{step}マス索敵を行いバリアアイテムが見つかった場合、青矢印に進みます。</br>見つからなかった場合、赤矢印に進みます。"
                (step) -> "左に#{step}マス索敵を行いバリアアイテムが見つかった場合、青矢印に進みます。</br>見つからなかった場合、赤矢印に進みます。"
                (step) -> "左上に#{step}マス索敵を行いバリアアイテムが見つかった場合、青矢印に進みます。</br>見つからなかった場合、赤矢印に進みます。"
                (step) -> "左下に#{step}マス索敵を行いバリアアイテムが見つかった場合、青矢印に進みます。</br>見つからなかった場合、赤矢印に進みます。"
            ]
        CurrentDirect :
            colnum : () -> " 方向"
            label : [ 
                () -> "右"
                () -> "右上"
                () -> "右下"
                () -> "左"
                () -> "左上"
                () -> "左下"
            ]
            description : [
                (step) -> "右を向いている場合、青矢印に進み、他の方向の場合赤矢印に進みます。"
                (step) -> "右上を向いている場合、青矢印に進み、他の方向の場合赤矢印に進みます。"
                (step) -> "右下を向いている場合、青矢印に進み、他の方向の場合赤矢印に進みます。"
                (step) -> "左を向いている場合、青矢印に進み、他の方向の場合赤矢印に進みます。"
                (step) -> "左上を向いている場合、青矢印に進み、他の方向の場合赤矢印に進みます。"
                (step) -> "左下を向いている場合、青矢印に進み、他の方向の場合赤矢印に進みます。"
            ]
