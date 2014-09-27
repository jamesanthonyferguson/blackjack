#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  initialize: ->

    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()


    @get('playerHand').on 'playerBusted', =>
      # @initialize()
      # @trigger 'resetRender'
      @delayedReset()

    @get('dealerHand').on 'dealerBusted', =>
      # @initialize()
      # @trigger 'resetRender'
      @delayedReset()

    @get('dealerHand').on 'gameComplete', =>
      console.log "gameComplete did trigger"
      playerValues = (@get 'playerHand').scores()
      dealerValues = (@get 'dealerHand').scores()
      console.log @determineWinner playerValues, dealerValues
      # @initialize()
      # @trigger 'resetRender'
      @delayedReset()

    @get('playerHand').on 'playerStood', =>
      console.log "I'm in your app, prompting your dealer"
      @promptDealer()

    @promptPlayer()


  delayedReset: ->
    setTimeout( =>
      @initialize()
      @trigger 'resetRender'
    ,1000)

  promptPlayer: ->

    (@get "playerHand").trigger "promptPlayer"

  promptDealer: ->
    (@get "dealerHand").trigger "promptDealer"
    console.log "app is sending a dealer prompt"

  determineWinner: (playerValues, dealerValues) ->
    # in this situation neither player has busted
    console.log(playerValues)
    console.log(dealerValues)

    tooBig = (n) ->
      n > 21

    playerScore = Math.max( (_.reject playerValues, tooBig)... )
    dealerScore = Math.max( (_.reject dealerValues, tooBig)... )

    console.log(playerScore, dealerScore)
    # dealer wins ties
    if playerScore > dealerScore then "player wins" else "dealer wins"
