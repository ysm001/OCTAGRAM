        
class Config
    @GAME_WIDTH = 640
    @GAME_HEIGHT = 640

class Config.R
    @RESOURCE_DIR : "resources"
    @CHAR :
        ROBOT : "#{R.RESOURCE_DIR}/robot/droid.png"
        E_ROBOT : "#{R.RESOURCE_DIR}/robot/e_droid.png"
    @BACKGROUND_IMAGE :
        HEADER : "#{R.RESOURCE_DIR}/background/header.png"
        HP_YELLOW : "#{R.RESOURCE_DIR}/background/hp_yellow.png"
        HP_BULE : "#{R.RESOURCE_DIR}/background/hp_blue.png"
        HEADER_UNDER_BAR : "#{R.RESOURCE_DIR}/background/hp_under_bar.png"
        TILE : "#{R.RESOURCE_DIR}/background/tile.png"
        MSGBOX : "#{R.RESOURCE_DIR}/background/msgbox.png"
        NEXT_BUTTON : "#{R.RESOURCE_DIR}/background/next_button.png"
    @UI :
        FONT0 : "#{R.RESOURCE_DIR}/ui/font0.png"
        ICON0 : "#{R.RESOURCE_DIR}/ui/icon0.png"
        PAD : "#{R.RESOURCE_DIR}/ui/pad.png"
        APAD : "#{R.RESOURCE_DIR}/ui/apad.png"

        #enchant.ui = { assets: [Config.R.PAD, Config.R.APAD, Config.R.FONT0, Config.R.ICON0] }
enchant()
enchant.ui = { assets: ['resources/ui/pad.png', 'resources/ui/apad.png', 'resources/ui/icon0.png', 'resources/ui/font0.png'] }
