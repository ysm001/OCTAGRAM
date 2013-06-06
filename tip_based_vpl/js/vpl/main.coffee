#####################################################
# TODO
# -リファクタリング
# -- group使って書き直し
# -- canvasに直す
# -- クラス分け
#####################################################

# for debug
board = null
executer = null

class Environment
  @ScreenWidth = 640 
  @ScreenHeight = 640 
  @EditorWidth = 480
  @EditorHeight = 480
  @EditorX = 16
  @EditorY = 16
  @startX = 4
  @startY = -1

class LayerOrder
  @background    = 10
  @transition    = 15
  @tip           = 20
  @tipIcon       = 21
  @tipEffect     = 22
  @frame         = 30
  @frameUI       = 31
  @frameUIIcon   = 32
  @frameUIArrow  = 33
  @frameUIEffect = 34
  @messageWindow = 40
  @messageText   = 45
  @dialog        = 50
  @dialogButton  = 55
  @dialogUI      = 56
  @dialogText    = 57
  @dialogIcon    = 58
  @dialogEffect  = 59
  @top           = 100
  
class GlobalUI
  @frame
  @help
  #@panel
  @configPanel
  @side

class TipTable
  @tips = []
  @addTip : (tip, icon) -> 
    #tip.setIcon(new Icon(icon)) if icon?
    @tips.push(tip)

  @addInstruction : (inst, icon) ->
    tip = TipFactory.createInstructionTip(inst) 
    #tip.setIcon(new Icon(icon)) if icon?
    #tip.icon = new Icon(icon) if icon?
    TipTable.addTip(tip)

class TipBasedVPL extends Game
  constructor : (w, h, resourceBase) ->
    super(w, h)
    @fps = 24
    Resources.base = resourceBase
    Resources.load(@)

  addInstruction : (instruction, icon) ->
    TipTable.addInstruction(instruction, icon)

  addPresetInstructions : () ->
    returnTip = TipFactory.createReturnTip(Environment.startX, Environment.startY)
    stopTip   = TipFactory.createStopTip() 
    nopTip  = TipFactory.createNopTip()
    inst = new RandomBranchInstruction()
    TipTable.addInstruction(inst, Resources.get("iconRandom"))
    TipTable.addTip(returnTip)
    TipTable.addTip(stopTip)
    TipTable.addTip(nopTip, Resources.get("iconNop"))

  clearInstructions : () -> @tips = []

  loadInstruction : () ->
    @clearInstructions()
    @addPresetInstructions()

    for tip in TipTable.tips then GlobalUI.side.addTip(tip)
      
    GlobalUI.side.show()

  onload : () ->
    x = 16
    y = 16
    xnum = 8
    ynum = 8

    back = new TipBackground(x, y, xnum, ynum)
    board = new Cpu(x + 12, y + 12, xnum, ynum, Environment.startX)
    executer = new Executer(board)

    GlobalUI.frame = new Frame(0, 0)
    GlobalUI.help = new HelpPanel(0, 
      Environment.EditorHeight + y, 
      Environment.ScreenWidth, 
      Environment.ScreenWidth - Environment.EditorWidth - x,
      "")
    GlobalUI.frame.show()
    GlobalUI.help.show()
    selector = new ParameterConfigPanel(Environment.EditorWidth + x/2, 0)

    GlobalUI.side = new SideTipSelector(Environment.EditorWidth + x/2, 0)
    GlobalUI.configPanel = new UIPanel(selector)
    GlobalUI.configPanel.setTitle(TextResource.msg.title["configurator"])
    selector.parent = GlobalUI.configPanel

