class LocalStorage
  save : (key, value) -> localStorage[key] = JSON.stringify(value)
  load : (key) -> JSON.parse(localStorage[key])

class ServerStorage
  save : (key, value) ->
  load : (key) ->
