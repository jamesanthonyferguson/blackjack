class window.AppView extends Backbone.View

  template: _.template '
    <div class="options-container"></div>
    <div class="player-hand-container"></div>
    <div class="dealer-hand-container"></div>
  '

  events:
    "click .hit-button": -> @model.get('playerHand').hit()
    "click .stand-button": -> @model.get('playerHand').stand()

  initialize: ->
    @render()
    @model.on "resetRender", =>
      @render()


  render: ->
    @$el.children().detach()
    @$el.html @template()
    @$('.options-container').html new window.OptionsView(model: @model.get 'playerHand').el
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el
