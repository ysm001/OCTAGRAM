class DirectionSelector extends SpriteGroup
  constructor : (range, type) ->
    key = if type == 'branch' then 'branchTip' else 'actionTip'
    super(Resources.get(key))

    @addChild(@sprite)

    rotStep = 45
    rot = 0
    @directions = []
    Direction.array.map((d) => 
      key = if type == 'branch' then 'selectorAlter' else 'selector'
      dir = new UIButton(Resources.get(key))

      dir.direction = d
      rate = 1/Math.sqrt(d.x * d.x + d.y * d.y)
      dir.rotate(rot)
      dir.moveTo(range * d.x * rate - dir.width/2 + @getWidth()/2, range * d.y * rate - dir.height/2 + @getHeight()/2)
      rot += rotStep

      dir.onClicked = () => 
        dir.isSelected = true
        @onSelected(dir.direction)
        dir.frame = 1

      @directions.push(dir)
      @addChild(dir)
    )

    @parent = null

  select : (direction) ->
    for dir in @directions 
      if dir.direction.x == direction.x && dir.direction.y == direction.y
         dir.isSelected = true
         dir.frame = 1

  ontouchstart : (e) -> 
    for dir in @directions 
      if dir.isSelected
        dir.isSelected = false
        dir.frame = 0

  onSelected : (d) ->

  show : (parent) -> 
    @parent = parent
    @parent.addChild(@)

  hide : () -> @parent.removeChild(@)

  @single : (parent) ->
    selector = new DirectionSelector(75, 'single')
    selector.show(parent)
    selector

  @branch : (parent) ->
    selector = new DirectionSelector(75, 'branch')
    selector.show(parent)
    selector

  #@dual : (parent) ->
  #  group = new Group()
  #  parent.addChild(group)
  #  single = DirectionSelector.single(group)
  #  branch = new DirectionSelector(120, 'branch').show(group)
  #  return group

  @dual : (parent) ->
    group = new Group()
    parent.addChild(group)
    single = DirectionSelector.single(group)
    branch = DirectionSelector.branch(group)
    single.moveTo(-100, 0)
    branch.moveTo(100, 0)
    group
