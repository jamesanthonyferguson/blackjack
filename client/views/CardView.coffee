class window.CardView extends Backbone.View

  className: 'card'

  #template: _.template ' of '
  template:
    _.template '<img src="img/cards/<%= rankName %>-<%= suitName %>.png" class = \'card\' ></img>'

  initialize: ->
    @model.on 'change', => @render
    @render()

  render: ->
    @$el.children().detach().end().html
    @$el.html @template @model.attributes

    unless @model.get 'revealed'
      @$el.children().first().attr("src", 'img/card-back.png')
