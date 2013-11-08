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

class OctagramContentSet
  constructor : (@x, @y, @xnum, @ynum) ->
    @octagrams = {}
    @currentInstance = null

  createInstance : () ->
    instance = new OctagramContent(@x, @y, @xnum, @ynum)
    @octagrams[instance.id] = instance
    instance

  removeInstance : (id) ->
  getInstance : (id) -> @octagrams[id]
  getCurrentInstance : () -> return @currentInstance

  show : (id) -> 
    @currentInstance.hide() if @currentInstance
    @currentInstance = @octagrams[id]
    @currentInstance.show()

class OctagramContent extends Group
  constructor : (x, y, xnum, ynum) ->
    super()
    @id = uniqueID()
    @tipSet = new TipSet()
    @userInstructions = []
    @cpu = new Cpu(x + 12, y + 12, xnum, ynum, Environment.startX, @)
    @executer = new Executer(@cpu)

    back = new TipBackground(x, y, xnum, ynum)
    @ui = {}
    @ui.frame = new Frame(0, 0)
    @ui.help = new HelpPanel(0, 
      Environment.EditorHeight + y, 
      Environment.ScreenWidth, 
      Environment.ScreenWidth - Environment.EditorWidth - x,
      "")
    selector = new ParameterConfigPanel(Environment.EditorWidth + x/2, 0)

    @ui.side = new SideTipSelector(Environment.EditorWidth + x/2, 0)
    @ui.configPanel = new UIPanel(selector)
    @ui.configPanel.setTitle(TextResource.msg.title["configurator"])
    selector.parent = @ui.configPanel

    @addChild(back)
    @addChild(@cpu)
    @addChild(@ui.frame)
    @addChild(@ui.side)
    @addChild(@ui.help)

    @addPresetInstructions()

  addInstruction : (instruction) ->
    @tipSet.addInstruction(instruction)
    @userInstructions.push(instruction)
  
  addUserInstructions : () ->
    for instruction in @userInstructions then @tipSet.addInstruction(instruction)

  addPresetInstructions : () ->
    stack = new StackMachine()
    counters = []
    for i in [0...100] 
      counters[i] = new Counter()

    returnTip = TipFactory.createReturnTip(Environment.startX, Environment.startY)
    stopTip   = TipFactory.createStopTip() 
    nopTip  = TipFactory.createNopTip()
    inst = new RandomBranchInstruction()

    @tipSet.addInstruction(inst, Resources.get("iconRandom"))
    @tipSet.addTip(returnTip)
    @tipSet.addTip(stopTip)
    @tipSet.addTip(nopTip, Resources.get("iconNop"))
    @tipSet.addInstruction(new CounterIncrementInstruction(counters), Resources.get("iconRandom"))
    @tipSet.addInstruction(new CounterDecrementInstruction(counters), Resources.get("iconRandom"))
    @tipSet.addInstruction(new CounterBranchInstruction(counters), Resources.get("iconRandom"))
    @tipSet.addInstruction(new CounterPushInstruction(counters, stack), Resources.get("iconRandom"))
    @tipSet.addInstruction(new CounterPopInstruction(counters, stack), Resources.get("iconRandom"))
    @tipSet.addInstruction(new StackAddInstruction(stack), Resources.get("iconRandom"))
    @tipSet.addInstruction(new StackSubInstruction(stack), Resources.get("iconRandom"))
    @tipSet.addInstruction(new StackMulInstruction(stack), Resources.get("iconRandom"))
    @tipSet.addInstruction(new StackDivInstruction(stack), Resources.get("iconRandom"))
    @tipSet.addInstruction(new StackModInstruction(stack), Resources.get("iconRandom"))
    @tipSet.addInstruction(new StackXorInstruction(stack), Resources.get("iconRandom"))
    @tipSet.addInstruction(new StackGrtInstruction(stack), Resources.get("iconRandom"))
    @tipSet.addInstruction(new StackSwpInstruction(stack), Resources.get("iconRandom"))
    @tipSet.addInstruction(new StackNotInstruction(stack), Resources.get("iconRandom"))
    @tipSet.addInstruction(new StackDupInstruction(stack), Resources.get("iconRandom"))
    @tipSet.addInstruction(new StackRotInstruction(stack), Resources.get("iconRandom"))
    @tipSet.addInstruction(new StackBnzInstruction(stack), Resources.get("iconRandom"))

  clearInstructions : () -> @tipSet.clear()

  load : (filename) -> @cpu.load(filename)
  save : (filename) -> @cpu.save(filename)

  serialize : () -> JSON.stringify(@cpu.serialize())
  deserialize : (serializedVal) -> @cpu.deserialize(JSON.parse(serializedVal))

  execute : (options) ->
    @dispatchEvent(new enchant.Event("onstart"))
    @executer.execute(options)

  stop : () ->
    @dispatchEvent(new enchant.Event("onstop"))
    @executer.stop()

  setTipToBar : () ->
    @clearInstructions()
    @ui.side.clearTip()

    @addUserInstructions()
    @addPresetInstructions()
    for tip in @tipSet.tips then @ui.side.addTip(tip)

  setMessage : (text) -> @ui.help.setText(text)

  show : () -> 
    @setTipToBar()
    Game.instance.currentScene.addChild(@)

  hide : () -> Game.instance.currentScene.removeChild(@)



octagram.TipSet = TipSet
octagram.OctagramContentSet = OctagramContentSet
octagram.OctagramContent = OctagramContent
