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
    @parentNode.removeChild(this)

class ExecutionEffect extends ImageSprite
  @fadeTime = 400

  constructor : () ->
    super(Resources.get("execEffect"))
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
      @tl.fadeOut(ExecutionEffect.fadeTime).then(@_hide)

  _hide : () =>
    @busy = false
    @visible = false
    @parentNode.removeChild(this)

octagram.SelectedEffect = SelectedEffect
octagram.ExecutionEffect = ExecutionEffect
