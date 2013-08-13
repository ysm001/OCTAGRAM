#####################################################
# TODO
# -リファクタリング
# - 保存機能
# - パラメータのみ保存(TipParameter)
# - チップテーブル作っておいて、初期状態はそっからコピー
# - 保存しておいたパラメータを使って復元
# - 必要なのは、チップテーブを参照するためのクラス名とパラメータ
#####################################################
class Environment
  @ScreenWidth = 640 
  @ScreenHeight = 640 
  @EditorWidth = 480
  @EditorHeight = 480

  @EditorX = 16
  @EditorY = 16

  @startX = 4
  @startY = -1

class TipTable
  @tips = []
  @clear : () -> @tips = []
  @addTip : (tip) -> @tips.push(tip)
  @addInstruction : (inst) ->
    tip = TipFactory.createInstructionTip(inst) 
    TipTable.addTip(tip)

  @findByInst : (instName) -> (tip for tip in @tips when tip.code.instruction? && tip.code.instruction.constructor.name == instName)[0]
  @findByCode : (codeName) -> (tip for tip in @tips when tip.code.constructor.name == codeName)[0]

class TipBasedVPL extends Game
  constructor : (w, h, resourceBase) ->
    super(w, h)
    @fps = 24
    Resources.base = resourceBase
    Resources.load(this)

  addInstruction : (instruction) ->
    TipTable.addInstruction(instruction)

  addPresetInstructions : () ->
    returnTip = TipFactory.createReturnTip(Environment.startX, Environment.startY)
    stopTip   = TipFactory.createStopTip() 
    nopTip  = TipFactory.createNopTip()
    inst = new RandomBranchInstruction()

    TipTable.addInstruction(inst, Resources.get("iconRandom"))
    TipTable.addTip(returnTip)
    TipTable.addTip(stopTip)
    TipTable.addTip(nopTip, Resources.get("iconNop"))
    TipTable.addInstruction(new StackAddInstruction(), Resources.get("iconRandom"))
    TipTable.addInstruction(new StackSubInstruction(), Resources.get("iconRandom"))
    TipTable.addInstruction(new StackMulInstruction(), Resources.get("iconRandom"))
    TipTable.addInstruction(new StackDivInstruction(), Resources.get("iconRandom"))
    TipTable.addInstruction(new StackModInstruction(), Resources.get("iconRandom"))
    TipTable.addInstruction(new StackXorInstruction(), Resources.get("iconRandom"))
    TipTable.addInstruction(new StackGrtInstruction(), Resources.get("iconRandom"))
    TipTable.addInstruction(new StackSwpInstruction(), Resources.get("iconRandom"))
    TipTable.addInstruction(new StackNotInstruction(), Resources.get("iconRandom"))
    TipTable.addInstruction(new StackDupInstruction(), Resources.get("iconRandom"))
    TipTable.addInstruction(new StackRotInstruction(), Resources.get("iconRandom"))
    TipTable.addInstruction(new StackBnzInstruction(), Resources.get("iconRandom"))

  clearInstructions : () -> TipTable.clear()

  loadInstruction : () ->
    @addPresetInstructions()

    for tip in TipTable.tips then Game.instance.vpl.ui.side.addTip(tip)

  onload : () ->
    x = 16
    y = 16
    xnum = 8
    ynum = 8

    back = new TipBackground(x, y, xnum, ynum)
    Game.instance.vpl = {}
    Game.instance.vpl.ui = {}
    Game.instance.vpl.cpu = new Cpu(x + 12, y + 12, xnum, ynum, Environment.startX)
    Game.instance.vpl.executer = new Executer(Game.instance.vpl.cpu)

    Game.instance.vpl.ui.frame = new Frame(0, 0)
    Game.instance.vpl.ui.help = new HelpPanel(0, 
      Environment.EditorHeight + y, 
      Environment.ScreenWidth, 
      Environment.ScreenWidth - Environment.EditorWidth - x,
      "")
    selector = new ParameterConfigPanel(Environment.EditorWidth + x/2, 0)

    Game.instance.vpl.ui.side = new SideTipSelector(Environment.EditorWidth + x/2, 0)
    Game.instance.vpl.ui.configPanel = new UIPanel(selector)
    Game.instance.vpl.ui.configPanel.setTitle(TextResource.msg.title["configurator"])
    selector.parent = Game.instance.vpl.ui.configPanel

    Game.instance.currentScene.addChild(back)
    Game.instance.currentScene.addChild(Game.instance.vpl.cpu)
    Game.instance.currentScene.addChild(Game.instance.vpl.ui.frame)
    Game.instance.currentScene.addChild(Game.instance.vpl.ui.side)
    Game.instance.currentScene.addChild(Game.instance.vpl.ui.help)

