#####################################################
# TODO
# -リファクタリング
# - データ構造の可視化
# -- スタックの中身やカウンタなど
#####################################################
class OctagramCore extends Core
  constructor : (x, y, w, h, resourceBase) ->
    super(w, h)
    #@fps = 24
    @octagrams = new OctagramContentSet(x, y, 8, 8)
    Resources.base = resourceBase
    Resources.load(this)

  onload : ->
