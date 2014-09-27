#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  initialize: ->

    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()


    @on 'playerBust', ->
      @initialize()

    @on 'dealerBust', ->
      @initialize()

    @on 'gameComplete', ->
      @initialize()

    @get('playerHand').on 'playerStood', =>
      console.log "I'm in your app, prompting your dealer"
      @promptDealer()

    @promptPlayer()

  promptPlayer: ->

    (@get "playerHand").trigger "promptPlayer"

  promptDealer: ->
    (@get "dealerHand").trigger "promptDealer"
    console.log "app is sending a dealer prompt"
