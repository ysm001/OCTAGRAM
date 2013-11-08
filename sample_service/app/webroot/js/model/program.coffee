class Program extends Backbone.Model
  @Cache: {}

  urlRoot: getRoot() + "programs/api/"

  constructor: (options) ->
    super options

  initialize: () ->

  parse: (res) ->
    ret = res.Program
    ret.battle_log = res.BattleLog
    ret
