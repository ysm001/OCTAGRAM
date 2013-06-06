#####################################################
# チップ選択時のエフェクト
#####################################################
class SelectedEffect extends Sprite
  constructor : () ->
    image = Resources.get("selectedEffect")
    super(image.width, image.height)
    @image = image
    @visible = false
    @dragMode = false

    @addEventListener('touchstart', (e) => @parent.dispatchEvent(e))
    @addEventListener('touchmove', (e) => @parent.dispatchEvent(e))
    @addEventListener('touchend', (e) => @parent.dispatchEvent(e))

    LayerUtil.setOrder(this, LayerOrder.tipEffect)

  show : (parent) ->
    @parent = parent
    @moveTo(@parent.x, @parent.y)

    @hide() if @visible
    @visible = true

    Game.instance.currentScene.addChild(this)

  hide : () ->
    @visible = false
    Game.instance.currentScene.removeChild(this)

class ExecutionEffect extends Sprite
  @fadeTime = 400
  constructor : (@parent) ->
    image = Resources.get("execEffect")
    super(image.width, image.height)
    @image = image
    @visible = false
    @busy = false
    @tl.setTimeBased()
    #@addEventListener('touchstart', => @hide())

    LayerUtil.setOrder(this, LayerOrder.tipEffect)

  show : () ->
    @moveTo(@parent.x, @parent.y)

    @tl.clear()
    @opacity = 1
    Game.instance.currentScene.addChild(this) if !@busy && !@visible
    @visible = true

  hide : () ->
    if @visible
      @tl.clear()
      @busy = true
      @tl.fadeOut(ExecutionEffect.fadeTime).then(
        () =>
          Game.instance.currentScene.removeChild(this)
          @busy = false
          @visible = false
          )
