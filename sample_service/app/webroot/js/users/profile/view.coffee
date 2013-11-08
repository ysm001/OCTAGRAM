
class ProgramView extends Backbone.View

  el: "div#program"

  template: _.template($('#program-tpl').html())

  constructor: (options = {}) ->
    super options

  initialize: () ->
    @model.on 'change:name', @render

  render: () =>
    @$el.html(@template(@model.attributes))
    return @

class UserProfileRouter extends Backbone.Router

  routes:
    "program/:query" : "program"
  
  constructor: (options = {}) ->
    super options

  initialize: () ->
    @program = new Program()
    @programsView = new ProgramView(model: @program)

  program: (query) ->
    unless Program.Cache[query]
      @program.set("id", query)
      @program.fetch
        success: (res) ->
          console.log res

$ ->
  window.router = new UserProfileRouter()
  Backbone.history.start()
