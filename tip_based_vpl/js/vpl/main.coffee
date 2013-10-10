#####################################################
# TODO
# -リファクタリング
# - データ構造の可視化
# -- スタックの中身やカウンタなど
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

class TipSet
  constructor : () ->
    @tips = []

  clear : () -> @tips = []
  addTip : (tip) -> @tips.push(tip)
  addInstruction : (inst) ->
    tip = TipFactory.createInstructionTip(inst) 
    @addTip(tip)

  findByInst : (instName) -> (tip for tip in @tips when tip.code.instruction? && tip.code.instruction.constructor.name == instName)[0]
  findByCode : (codeName) -> (tip for tip in @tips when tip.code.constructor.name == codeName)[0]

class VirtualMachine
  constructor : (x, y, xnum, ynum) ->
    @tipSet = new TipSet()
    @cpu = new Cpu(x + 12, y + 12, xnum, ynum, Environment.startX, @tipSet)
    @executer = new Executer(@cpu)

  addInstruction : (instruction) ->
    @cpu.tipSet.addInstruction(instruction)

  addPresetInstructions : () ->
    stack = new StackMachine()
    counters = []
    for i in [0...100] 
      counters[i] = new Counter()

    returnTip = TipFactory.createReturnTip(Environment.startX, Environment.startY)
    stopTip   = TipFactory.createStopTip() 
    nopTip  = TipFactory.createNopTip()
    inst = new RandomBranchInstruction()

    @cpu.tipSet.addInstruction(inst, Resources.get("iconRandom"))
    @cpu.tipSet.addTip(returnTip)
    @cpu.tipSet.addTip(stopTip)
    @cpu.tipSet.addTip(nopTip, Resources.get("iconNop"))
    @cpu.tipSet.addInstruction(new CounterIncrementInstruction(counters), Resources.get("iconRandom"))
    @cpu.tipSet.addInstruction(new CounterDecrementInstruction(counters), Resources.get("iconRandom"))
    @cpu.tipSet.addInstruction(new CounterBranchInstruction(counters), Resources.get("iconRandom"))
    @cpu.tipSet.addInstruction(new CounterPushInstruction(counters, stack), Resources.get("iconRandom"))
    @cpu.tipSet.addInstruction(new CounterPopInstruction(counters, stack), Resources.get("iconRandom"))
    @cpu.tipSet.addInstruction(new StackAddInstruction(stack), Resources.get("iconRandom"))
    @cpu.tipSet.addInstruction(new StackSubInstruction(stack), Resources.get("iconRandom"))
    @cpu.tipSet.addInstruction(new StackMulInstruction(stack), Resources.get("iconRandom"))
    @cpu.tipSet.addInstruction(new StackDivInstruction(stack), Resources.get("iconRandom"))
    @cpu.tipSet.addInstruction(new StackModInstruction(stack), Resources.get("iconRandom"))
    @cpu.tipSet.addInstruction(new StackXorInstruction(stack), Resources.get("iconRandom"))
    @cpu.tipSet.addInstruction(new StackGrtInstruction(stack), Resources.get("iconRandom"))
    @cpu.tipSet.addInstruction(new StackSwpInstruction(stack), Resources.get("iconRandom"))
    @cpu.tipSet.addInstruction(new StackNotInstruction(stack), Resources.get("iconRandom"))
    @cpu.tipSet.addInstruction(new StackDupInstruction(stack), Resources.get("iconRandom"))
    @cpu.tipSet.addInstruction(new StackRotInstruction(stack), Resources.get("iconRandom"))
    @cpu.tipSet.addInstruction(new StackBnzInstruction(stack), Resources.get("iconRandom"))

  clearInstructions : () -> @tipSet.clear()

  #loadInstruction : () ->
  #  @addPresetInstructions()
  #  for tip in @cpu.tipSet.tips then Game.instance.vpl.ui.side.addTip(tip)

  show : () -> 
    @addPresetInstructions()
    for tip in @cpu.tipSet.tips then Game.instance.vpl.ui.side.addTip(tip)

    Game.instance.currentScene.insertBefore(@cpu, Game.instance.vpl.ui.frame)

class TipBasedVPL extends Game
  constructor : (w, h, resourceBase) ->
    super(w, h)
    @fps = 24
    Resources.base = resourceBase
    Resources.load(this)

  onload : () ->
    x = 16
    y = 16
    xnum = 8
    ynum = 8

    back = new TipBackground(x, y, xnum, ynum)
    Game.instance.vpl = {}
    Game.instance.vpl.ui = {}
    Game.instance.vpl.currentVM= new VirtualMachine(x, y, xnum, ynum)

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
    #Game.instance.currentScene.addChild(Game.instance.vpl.cpu)
    Game.instance.currentScene.addChild(Game.instance.vpl.ui.frame)
    Game.instance.currentScene.addChild(Game.instance.vpl.ui.side)
    Game.instance.currentScene.addChild(Game.instance.vpl.ui.help)

    #Game.instance.vpl.currentVM.show()
