class Command
    constructor: (@instruction, @args = null)->

    eval: (robot) ->
        @instruction.func.apply robot, @args

class CommandQueue
    constructor: (@collection = []) ->

    enqueue: (item) ->
        @collection.push item

    dequeue: () ->
        @collection.shift()

    empty: () ->
        @collection.length == 0

class CommandIterator
    constructor: (@collection) ->
        @i = 0

    next: () ->
        @collection[@i++] if @hasNext() is true

    hasNext: () ->
        @collection.length > @i



