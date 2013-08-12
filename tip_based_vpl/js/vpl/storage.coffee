class LocalStorage
  save : (key, value) -> localStorage.setItem(key, JSON.stringify(value))
  load : (key) -> JSON.parse(localStorage.getItem(key))

class ServerStorage
  save : (key, value) ->
  load : (key) ->
