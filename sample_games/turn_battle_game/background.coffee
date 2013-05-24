R = Config.R

class Header extends Sprite
    @WIDTH = 640
    @HEIGHT = 32
    constructor: (x,y) ->
        super Header.WIDTH, Header.HEIGHT
        @x = x
        @y = y
        @image = Game.instance.assets[R.BACKGROUND_IMAGE.HEADER]

class HeaderHp extends Sprite
    @WIDTH = 130
    @HEIGHT = 24
    constructor: (x,y) ->
        super HeaderHp.WIDTH, HeaderHp.HEIGHT
        @x = x
        @y = y
        @image = Game.instance.assets[R.BACKGROUND_IMAGE.HEADER_HP]

class Tile extends Sprite
    @SIZE = 64
    constructor: (x,y) ->
        super Tile.SIZE, Tile.SIZE
        @x = x
        @y = y
        @image = Game.instance.assets[R.BACKGROUND_IMAGE.TILE]

    setSelected: () ->
        @frame = 1

    setNormal: () ->
        @frame = 0

class MsgBox extends Sprite
    @WIDTH = 500
    @HEIGHT = 150
    constructor: (x,y) ->
        super MsgBox.WIDTH, MsgBox.HEIGHT
        @x = x
        @y = y
        @image = Game.instance.assets[R.BACKGROUND_IMAGE.MSGBOX]


class Button extends Sprite
    @WIDTH = 120
    @HEIGHT = 50
    constructor: (x,y) ->
        super Button.WIDTH, Button.HEIGHT
        @x = x
        @y = y
    setOnClickEventListener: (listener) ->
        @on_click_event = listener
    ontouchstart: ->
        @on_click_event() if @on_click_event?
        @frame = 1

    ontouchend: ->
        @frame = 0

class NextButton extends Button
    constructor: (x,y) ->
        super x, y
        @image = Game.instance.assets[R.BACKGROUND_IMAGE.NEXT_BUTTON]


class Map extends Group
    @WIDTH = 10
    @HEIGHT = 7
    @UNIT_SIZE = Tile.SIZE

    constructor: (x, y)->
        super
        @matrix = []
        # backgrond images
        for ty in [0..Map.HEIGHT - 1]
            for tx in [0..Map.WIDTH - 1]
                tile = new Tile((tx * Map.UNIT_SIZE), (ty * Map.UNIT_SIZE))
                @matrix.push tile
                @addChild tile
        @x = x
        @y = y
        @width = Map.WIDTH * Map.UNIT_SIZE
        @height = Map.HEIGHT * Map.UNIT_SIZE
        Map.instance = @

    getTileByPos: (posx, posy) ->
        @matrix[posy * Map.WIDTH + posx]

    getTile: (x, y) ->
        @matrix[@getPosY(y) * Map.WIDTH + @getPosX(x)]
        
    getX: (posX) ->
        posX * Map.UNIT_SIZE + @x
    getY: (posY) ->
        posY * Map.UNIT_SIZE + @y
    getPosX: (x) ->
        x = parseInt(x)
        tmpx = (x - @x)
        base = tmpx - (tmpx % Map.UNIT_SIZE)
        if tmpx > base + Map.UNIT_SIZE/2
            return base / Map.UNIT_SIZE + 1
        else
            return base / Map.UNIT_SIZE
    getPosY: (y) ->
        y = parseInt(y)
        tmpx = (y - @y)
        base = tmpx - (tmpx % Map.UNIT_SIZE)
        if tmpx > base + Map.UNIT_SIZE/2
            return base / Map.UNIT_SIZE + 1
        else
            return base / Map.UNIT_SIZE
        



