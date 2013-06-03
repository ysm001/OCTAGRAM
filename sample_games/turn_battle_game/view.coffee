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

class Plate extends Sprite
    @HEIGHT = 74
    @WIDTH = 64
    constructor: (x, y, @ix, @iy) ->
        super Plate.WIDTH, Plate.HEIGHT
        @x = x
        @y = y
        @image = Game.instance.assets[R.BACKGROUND_IMAGE.PLATE]

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

    getAbsolutePos: () ->
        i = @parentNode
        offsetX = offsetY = 0
        while i?
            offsetX += i.x
            offsetY += i.y
            i = i.parentNode

        new Point(@x + offsetX, @y + offsetY)

class Map extends Group
    @WIDTH = 9
    @HEIGHT = 7
    @UNIT_HEIGHT = Plate.HEIGHT
    @UNIT_WIDTH = Plate.WIDTH

    constructor: (x, y)->
        if Map.instance?
            return Map.instance
        super
        Map.instance = @
        @plateMatrix = []
        offset = 64/4
        # backgrond images
        for ty in [0...Map.HEIGHT]
            list = []
            for tx in [0...Map.WIDTH]
                if ty % 2 == 0
                    plate = new Plate(tx * Map.UNIT_WIDTH , (ty * Map.UNIT_HEIGHT) - ty * offset, tx, ty)
                else
                    plate = new Plate((tx * Map.UNIT_WIDTH+Map.UNIT_HEIGHT/2), (ty * Map.UNIT_HEIGHT)- ty * offset, tx, ty)
                list.push plate
                @addChild plate
            @plateMatrix.push list
        @x = x
        @y = y
        @width = Map.WIDTH * Map.UNIT_WIDTH
        @height = (Map.HEIGHT-1) * (Map.UNIT_HEIGHT - offset) + Map.UNIT_HEIGHT + 16
        @object = {}

    getTargetPoision:(plate, direct=Direct.RIGHT) ->
        if direct == Direct.RIGHT
            if @plateMatrix[plate.iy].length > plate.ix + 1
                return @plateMatrix[plate.iy][plate.ix+1]
            else
                return null
        else if direct == Direct.LEFT
            if plate.ix > 0
                return @plateMatrix[plate.iy][plate.ix-1]
            else
                return null

        if (direct & Direct.RIGHT) != 0 and (direct & Direct.UP) != 0
            offset = if plate.iy % 2 == 0 then 0 else 1
            if offset + plate.ix < Map.WIDTH and plate.iy > 0
                return @plateMatrix[plate.iy-1][offset + plate.ix]
            else
                return null
        else if (direct & Direct.RIGHT) != 0 and (direct & Direct.DOWN) != 0
            offset = if plate.iy % 2 == 0 then 0 else 1
            if offset + plate.ix < Map.WIDTH and plate.iy+1 < Map.HEIGHT
                return @plateMatrix[plate.iy+1][offset + plate.ix]
            else
                return null
        else if (direct & Direct.LEFT) != 0 and (direct & Direct.UP) != 0
            offset = if plate.iy % 2 == 0 then -1 else 0
            if offset + plate.ix >= 0 and plate.iy > 0
                return @plateMatrix[plate.iy-1][offset + plate.ix]
            else
                return null
        else if (direct & Direct.LEFT) != 0 and (direct & Direct.DOWN) != 0
            offset = if plate.iy % 2 == 0 then -1 else 0
            if offset + plate.ix >= 0 and plate.iy+1 < Map.HEIGHT
                return @plateMatrix[plate.iy+1][offset + plate.ix]
            else
                return null
        
        return null


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
        @label.x = 30
        @label.y = 30
        @addChild @label
        @label.width = MsgWindow.WIDTH * 0.85

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


class RemainingBullet extends Sprite
    @SIZE = 24
    constructor: (x, y) ->
        super 24, 24
        @x = x
        @y = y
        @image = Game.instance.assets[R.ITEM.STATUS_BULLET]

class RemainingBullets extends Group

    @HEIGHT = 100
    @WIDTH = 120
    constructor: (x, y) ->
        super RemainingBullets.WIDTH, RemainingBullets.HEIGHT
        @x = x
        @y = y
        @size = 0
        @stack = new Stack 5

    increment: () ->
        b = new RemainingBullet(@size * RemainingBullet.SIZE ,0)
        @stack.push b
        @size++
        @addChild b if b?

    decrement: () ->
        b = @stack.pop()
        @size--
        @removeChild b if b?

class StatusBox extends Group

    constructor: (x,y) ->
        super StatusWindow.WIDTH, StatusWindow.HEIGHT
        @x = x
        @y = y
        @window = new StatusWindow 0, 0
        @addChild @window
        @label = new Label("弾:")
        @label.font = "16px 'Meiryo UI'"
        @label.color = '#FFF'
        @label.x = 30
        @label.y = 30
        @addChild @label
        @label.width = MsgWindow.WIDTH * 0.25

        @remainingBullets = new RemainingBullets 30, 30
        @addChild @remainingBullets


class Footer extends Group
    constructor: (x,y) ->
        super
        @x = x
        @y = y
        @msgbox = new MsgBox 0,0
        @addChild @msgbox
        @statusBox = new StatusBox x+MsgWindow.WIDTH-10,0
        @addChild @statusBox

