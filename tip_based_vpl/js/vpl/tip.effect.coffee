#####################################################
# チップ選択時のエフェクト
#####################################################
class SelectedEffect extends ImageSprite
  constructor : () ->
    super(Resources.get("selectedEffect"))
    @visible = false
    @touchEnabled = false

  show : (parent) ->
    @visible = true
    parent.addChild(this)

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

  show : (parent) ->
    @tl.clear()
    @opacity = 1
    parent.addChild(this) if !@busy && !@visible
    @visible = true

  hide : () ->
    if @visible
      @tl.clear()
      @busy = true
      @tl.fadeOut(ExecutionEffect.fadeTime).then(
        () =>
          @parentNode.removeChild(this)
          @busy = false
          @visible = false
          )
