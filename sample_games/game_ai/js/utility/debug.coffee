
DEBUG = true
class Debug
  @log: (obj) ->
    DEBUG && console.log "[AIGame Log]#{obj}"
  @dump: (obj) ->
    DEBUG && console.log obj
