
class ProgramView extends Backbone.View

  el: "div#program"

  template: _.template($('#program-tpl').html())

  constructor: (options = {}) ->
    super options

  initialize: () ->
    @model.on 'change:name', @render

  render: () =>
    @ids = @model.attributes.battle_log.map (item) -> item.id
    @values = @model.attributes.battle_log.map (item) -> parseInt(item.rate)
    @$el.html(@template(@model.attributes))
    $('#graph-container').highcharts({
            title: {
                text: 'レートの変動値',
                x: -20
            },
            xAxis: {
                categories: @ids
            },
            yAxis: {
                title: {
                    text: 'レート'
                },
                plotLines: [{
                    value: 0,
                    width: 1,
                    color: '#808080'
                }]
            },
            legend: {
                layout: 'vertical',
                align: 'right',
                verticalAlign: 'middle',
                borderWidth: 0
            },
            series: [{
                name: 'レート',
                data: @values
            }
            ]
        })
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

$ ->
  window.router = new UserProfileRouter()
  Backbone.history.start()
