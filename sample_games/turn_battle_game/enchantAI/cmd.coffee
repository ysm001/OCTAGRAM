class Command
    constructor: (@instruction, @args = null)->

    eval: (robot) ->
        @instruction.func.apply robot, @args

class CommandIterator
    constructor: (@collection) ->
        @i = 0

    next: () ->
        @collection[@i++] if @hasNext() is true

    hasNext: () ->
        @collection.length > @i



