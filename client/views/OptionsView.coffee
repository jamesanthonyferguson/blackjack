class window.OptionsView extends Backbone.View

  className: 'player-options'

  template: '<button class="hit">Hit me Baby!</button><button class="stand">Stand your ground!</button><button class="double">Double down!</button>'

  initialize: ->
    @render()

  render: ->
    @$el.html @template
    @$el.append
    @$el.children().first().on 'click', =>
      if @model.acceptViewInput then @model.trigger 'hit'
    @$el.children().first().next().on 'click', =>
      if @model.acceptViewInput then @model.trigger 'stood'
    @$el.children().first().next().next().on 'click', =>
      if @model.acceptViewInput and @model.acceptDoubleDown then @model.trigger 'double'
