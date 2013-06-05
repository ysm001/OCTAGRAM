#####################################################
# TODO
# -リファクタリング
# -- group使って書き直し
# -- canvasに直す
# -- クラス分け
#####################################################

class Environment
  @ScreenWidth = 640 
  @ScreenHeight = 640 
  @EditorWidth = 480
  @EditorHeight = 480
  @EditorX = 16
  @EditorY = 16

  @layer = { 
    background    : 10,
    transition    : 15,
    tip           : 20,
    tipIcon       : 21,
    tipEffect     : 22,
    frame         : 30,
    frameUI       : 31,
    frameUIIcon   : 32,
    frameUIArrow  : 33,
    frameUIEffect : 34,
    messageWindow : 40,
    messageText   : 45,
    dialog        : 50,
    dialogButton  : 55,
    dialogUI      : 56,
    dialogText    : 57,
    dialogIcon    : 58,
    dialogEffect  : 59,
    top           : 100,
  }

class Configure
  #@latency = 30
  
class GlobalUI
  @frame
  @help
  @panel
  @configPanel
  @side

class TipTable
  @tips = []
  @addTip : (tip) -> @tips.push(tip)
  @addInstruction : (inst, icon) ->
    tip = TipFactory.createInstructionTip(inst) 
    #tip.description = description
    tip.icon = new Icon(icon) if icon?
    TipTable.addTip(tip)

class ClipBoard
  @data = null

board = null
executer = null
errorChecker = new ErrorChecker()

class TipBasedVPL extends Game
  constructor : (w, h, resourceBase) ->
    super(w, h)
    @fps = 24
    Resources.base = resourceBase
    Resources.load(@)

  addInstruction : (instruction, icon) ->
    TipTable.addInstruction(instruction, icon)

  loadInstruction : () ->
    sx = 4
    sy = -1
    returnTip = TipFactory.createReturnTip(sx, sy)
    stopTip   = TipFactory.createStopTip() 
    inst = new RandomBranchInstruction()
    TipTable.addInstruction(inst, Resources.get("iconRandom"))
    TipTable.addTip(returnTip)
    TipTable.addTip(stopTip)

    for tip in TipTable.tips
      GlobalUI.side.addTip(tip)
      
    GlobalUI.side.show()

  onload : () ->
    x = 16
    y = 16
    xnum = 8
    ynum = 8
    back = new TipBackground(x, y, xnum, ynum)
    #border = new Border(x, y, xnum, ynum)
    board = new TipBoard(x + 12, y + 12, xnum, ynum, 4)
    executer = new Executer(board)
    GlobalUI.frame = new Frame(0, 0)
    GlobalUI.help = new HelpPanel(0,480+16,640,144, "")
    GlobalUI.frame.show()
    GlobalUI.help.show()
    selector = new ParameterConfigPanel(480 + 8, 0)#new UITipSelector()
    param1 = new TipParameter("a", 0, 0, 100, 1)
    param2 = new TipParameter("a", 0, 0, 5, 1)
    ###
    selector.addParameter(param1)
    selector.addParameter(param2)
    ###

    GlobalUI.side = new SideTipSelector(480 + 8, 0)

    ###
    slider = new Slider()
    slider.moveTo(100,100)
    slider.show()
    ###

    #selector.moveTo(64,64)
    initializeTester(4, -1)
    ###
    for tip in TipTable.tips
      #selector.addTip(tip)
      GlobalUI.side.addTip(tip)
    ###

    configurator = new UITipConfigurator()
    configurator.moveTo(64,64)

    #GlobalUI.side.show()

    page1 = new Page(selector, TextResource.msg.title["selector"])
    page2 = new Page(configurator, TextResource.msg.title["configurator"])
    page1.next = page2
    page2.prev = page1
    GlobalUI.configPanel = new UIPanel(selector)
    GlobalUI.configPanel.setTitle(TextResource.msg.title["configurator"])
    selector.parent = GlobalUI.configPanel

###
window.onload = ->
  game = new TipBasedVPL(Environment.ScreenWidth, Environment.ScreenHeight, "./")
  game.start()
###
