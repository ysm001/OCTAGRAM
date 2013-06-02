R = Config.R

class Header extends Sprite
    @WIDTH = 640
    @HEIGHT = 32
    constructor: (x,y) ->
        super Header.WIDTH, Header.HEIGHT
        @x = x
        @y = y
        @image = Game.instance.assets[R.BACKGROUND_IMAGE.HEADER]


class HpBar extends Bar
    constructor: (x,y,resource=PlayerHp.YELLOW) ->
        super x, y
        @height = Header.HEIGHT
        @value = Header.WIDTH / 2
        @maxValue = Header.WIDTH / 2
        switch resource
            when PlayerHp.BLUE
                @image = Game.instance.assets[R.BACKGROUND_IMAGE.HP_BULE]
            when PlayerHp.YELLOW
                @image = Game.instance.assets[R.BACKGROUND_IMAGE.HP_YELLOW]

class HpUnderBar extends Sprite
    @WIDTH = Header.WIDTH / 2
    @HEIGHT = Header.HEIGHT
    constructor: (x, y) ->
        super HpUnderBar.WIDTH, HpUnderBar.HEIGHT
        @x = x
        @y = y
        @height = Header.HEIGHT
        @image = Game.instance.assets[R.BACKGROUND_IMAGE.HEADER_UNDER_BAR]

class Background extends Sprite
    @SIZE = 640
    constructor: (x, y) ->
        super Background.SIZE, Background.SIZE
        @image = Game.instance.assets[R.BACKGROUND_IMAGE.SPACE]

class PlayerHp extends Group
    @YELLOW = 1
    @BLUE = 2
    @MAX_HP = 4
    constructor: (x,y, resource) ->
        super
        @hp = new HpBar x, y, resource
        @addChild @hp
        @underBar = new HpUnderBar x, y
        @addChild @underBar
    direct: (direct) ->
        @underBar.scale(-1, 1)
        @hp.direction = direct
        # TODO:
        # doing by force !!
        @hp.x = Header.WIDTH
    reduce: () ->
        @hp.value -= @hp.maxValue / PlayerHp.MAX_HP if @hp.value > 0

class Tile extends Sprite
    @SIZE = 64
    constructor: (x,y) ->
        super Tile.SIZE, Tile.SIZE
        @x = x
        @y = y
        @image = Game.instance.assets[R.BACKGROUND_IMAGE.TILE]

    setPlayerSelected: () ->
        @frame = 1
        map = Map.instance
        map.object[@frame] = new Point map.x + @x, map.y + @y

    setEnemySelected: () ->
        @frame = 2
        map = Map.instance
        map.object[@frame] = new Point map.x + @x, map.y + @y

    setNormal: () ->
        @frame = 0

class Map extends Group
    @WIDTH = 10
    @HEIGHT = 7
    @UNIT_SIZE = Tile.SIZE

    constructor: (x, y)->
        if Map.instance?
            return Map.instance
        super
        Map.instance = @
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
        @object = {}

    isIntersect: (x, y) ->
        #Debug.log "#{@getPosX(x)},#{@getPosX(y)}"
        for k,v of @object
            #Debug.log "#{k}=#{@getPosX(v.x)},#{@getPosY(v.y)}"
            if @getPosX(v.x) == @getPosX(x) and @getPosY(v.y) == @getPosY(y)
                return true
        return false

    getTileByPos: (posx, posy) ->
        @matrix[posy * Map.WIDTH + posx]

    getTile: (x, y) ->
        @matrix[@getPosY(y) * Map.WIDTH + @getPosX(x)]
        
    getX: (posX) ->
        posX * Map.UNIT_SIZE + @x

    getY: (posY) ->
        posY * Map.UNIT_SIZE + @y

    getPos: (x, y) ->
        return new Point @getPosX(x), @getPosY(y)

    getPosX: (x) ->
        x = parseInt(x)
        tmpx = (x - @x)
        base = tmpx - (tmpx % Map.UNIT_SIZE)
        if tmpx >= base + Map.UNIT_SIZE/2
            return base / Map.UNIT_SIZE + 1
        else
            return base / Map.UNIT_SIZE
    getPosY: (y) ->
        y = parseInt(y)
        tmpx = (y - @y)
        base = tmpx - (tmpx % Map.UNIT_SIZE)
        if tmpx >= base + Map.UNIT_SIZE/2
            return base / Map.UNIT_SIZE + 1
        else
            return base / Map.UNIT_SIZE

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


class MsgWindow extends Sprite
    @WIDTH = 450
    @HEIGHT = 150
    constructor: (x,y) ->
        super MsgWindow.WIDTH, MsgWindow.HEIGHT
        @x = x
        @y = y
        @image = Game.instance.assets[R.BACKGROUND_IMAGE.MSGBOX]

class MsgBox extends Group

    constructor: (x,y) ->
        super MsgWindow.WIDTH, MsgWindow.HEIGHT
        @x = x
        @y = y
        @window = new MsgWindow 0, 0
        @addChild @window
        @label = new Label
        @label.font = "16px 'Meiryo UI'"
        @label.color = '#FFF'
        @label.x = 25
        @label.y = 25
        @addChild @label
        @label.width = MsgWindow.WIDTH * 0.85
        @print "sassssssssssssssssssssssssssssssssssssssssssssssssss"

    print: (msg) ->
        @label.text = "#{msg}"

class StatusWindow extends Sprite
    @WIDTH = 180
    @HEIGHT = 150
    constructor: (x,y) ->
        super StatusWindow.WIDTH, StatusWindow.HEIGHT
        @x = x
        @y = y
        @image = Game.instance.assets[R.BACKGROUND_IMAGE.STATUS_BOX]

class StatusBox extends Group

    constructor: (x,y) ->
        super StatusWindow.WIDTH, StatusWindow.HEIGHT
        @x = x
        @y = y
        @window = new StatusWindow 0, 0
        @addChild @window
        @label = new Label
        @label.font = "16px 'Meiryo UI'"
        @label.color = '#FFF'
        @label.x = 25
        @label.y = 25
        @addChild @label
        @label.width = MsgWindow.WIDTH * 0.25

    print: (msg) ->
        @label.text = "#{msg}"

class Footer extends Group
    constructor: (x,y) ->
        super
        @x = x
        @y = y
        @msgbox = new MsgBox 0,0
        @addChild @msgbox
        @statusBox = new StatusBox x+MsgWindow.WIDTH-10,0
        @addChild @statusBox

