enchant()
        
class Config
    @GAME_WIDTH = 640
    @GAME_HEIGHT = 640

class Config.R
    @RESOURCE_DIR : "resources"
    @CHAR :
        ROBOT : "#{R.RESOURCE_DIR}/robot/droid.png"
    @BACKGROUND_IMAGE :
        HEADER : "#{R.RESOURCE_DIR}/background/header.png"
        HEADER_HP : "#{R.RESOURCE_DIR}/background/star.png"
        TILE : "#{R.RESOURCE_DIR}/background/tile.png"
        MSGBOX : "#{R.RESOURCE_DIR}/background/msgbox.png"
        NEXT_BUTTON : "#{R.RESOURCE_DIR}/background/next_button.png"
