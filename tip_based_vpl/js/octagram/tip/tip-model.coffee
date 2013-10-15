#####################################################
# チップ関連
#####################################################


#####################################################
# チップ 
#####################################################
class Tip
  constructor : () ->
    @transitions = {}
    @index = {x:0, y:0}
  addTransition : (name, dst) -> @transitions[name] = dst
  getTransition : (name) -> @transitions[name]
  clone : () -> new Tip() 
  copy : (obj) ->
    obj.index.x = @index.x
    obj.index.y = @index.y
    for t of @transitions
      obj.transitions[t] = @transitions[t]
    obj
  execute : () -> null

  mkDescription : () -> TipUtil.tipToMessage(this) 

  serialize : () ->
    name:  @constructor.name
    index: @index
    transitions: @transitions

  deserialize : (serializedVal) ->
    @transitions = serializedVal.transitions
    @index = serializedVal.index

#####################################################
# Emptyチップ
# 何も命令の入っていないチップ
# 遷移も持たない
#####################################################
class EmptyTip extends Tip
  constructor : () -> super()
  clone : () -> new EmptyTip()

class StopTip extends Tip
  constructor : () -> super()
  clone : () -> new StopTip()

#####################################################
# 単一の遷移(next)しかもたないチップ
#####################################################
class SingleTransitionTip extends Tip 
  constructor : (next) ->
    super()
    @setNext(next)

  setNext : (next) ->
    @next = next
    @addTransition("next", @next)

  getNext : () -> @getTransition("next")

  execute : () -> @getTransition("next")
  clone : () -> @copy(new SingleTransitionTip(@getNext()))

#####################################################
# Thinkチップ
# 特殊チップ(nop, sub routine etc...)
#####################################################
class ThinkTip extends SingleTransitionTip
  constructor : (next) -> super(next)
  clone : () -> @copy(new ThinkTip(@getNext()))

#####################################################
# Nopチップ
#####################################################
class NopTip extends ThinkTip
  constructor : (next) -> super(next)
  clone : () -> @copy(new NopTip(@getNext()))

#####################################################
# 何もしないで次へ遷移するチップ
# Return ,Startチップがこれに該当
#####################################################
class StartTip extends SingleTransitionTip
  constructor : (next) -> super(next)
  clone : () -> @copy(new StartTip(@getNext()))

class ReturnTip extends SingleTransitionTip
  constructor : (next) -> super(next)
  clone : () -> @copy(new ReturnTip(@getNext()))

class WallTip extends SingleTransitionTip
  constructor : (next) -> super(next)
  clone : () -> @copy(new WallTip(@getNext()))

#####################################################
# Branchチップ
# 条件分岐を行うチップ
# 二つの遷移(conseq,alter)を持つ
# 条件を満たせばconseq, 満たさなければalterへ遷移
#####################################################
class BranchTip extends Tip 
  constructor : (conseq, alter) ->
    super()
    @addTransition("conseq", conseq)
    @addTransition("alter", alter)

  condition : () -> true

  execute : () ->
    super
    if @condition() then @getTransition("conseq") 
    else @getTransition("alter")
  
  setConseq : (conseq) -> @addTransition("conseq", conseq)
  setAlter : (alter) -> @addTransition("alter", alter)
  getConseq : () -> @getTransition("conseq")
  getAlter : () -> @getTransition("alter")

  clone : () -> @copy(new BranchTip(@getConseq(), @getAlter()))

#####################################################
# Actionチップ
# アクションを実行して次へ遷移するチップ
#####################################################
class ActionTip extends SingleTransitionTip 
  constructor : (next) -> super(next)

  action : () ->

  execute : () ->
    @action()
    @getTransition("next")

  clone : () -> tip = @copy(new ActionTip(@getNext()))
