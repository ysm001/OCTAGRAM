#####################################################
# TODO
# -リファクタリング
# - データ構造の可視化
# -- スタックの中身やカウンタなど
#####################################################
class TipBasedVPL extends Game
  constructor : (w, h, resourceBase) ->
    super(w, h)
    @fps = 24
    @octagrams = new OctagramSet(16, 16, 8, 8)
    Resources.base = resourceBase
    Resources.load(this)

  onload : () ->
    x = 16
    y = 16
    xnum = 8
    ynum = 8

    Game.instance.vpl = {}
    Game.instance.vpl.currentVM= new Octagram(x, y, xnum, ynum)
