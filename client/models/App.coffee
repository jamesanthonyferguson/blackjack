#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  initialize: ->

    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()


    @get('playerHand').on 'playerBusted', =>
      console.log "You've busted! The dealer wins!"
      @delayedReset()

    @get('dealerHand').on 'dealerBusted', =>
      console.log "The dealer has busted. You win!"
      @delayedReset()

    @get('dealerHand').on 'gameComplete', =>
      @trigger 'resetRender'
      console.log "The game is over."
      playerValues = (@get 'playerHand').scores()
      dealerValues = (@get 'dealerHand').scores()
      console.log @determineWinner playerValues, dealerValues
      @delayedReset()

    @get('playerHand').on 'playerStood', =>
      @promptDealer()

    @promptPlayer()


  delayedReset: ->
    setTimeout( =>
      @initialize()
      @trigger 'resetRender'
    ,1000)


  determineWinner: (playerValues, dealerValues) ->
    # in this situation neither player has busted

    tooBig = (n) ->
      n > 21

    playerScore = Math.max( (_.reject playerValues, tooBig)... )
    dealerScore = Math.max( (_.reject dealerValues, tooBig)... )

    # when we're determining the winner, update the scores to the best score possible i.e. playerScore or dealerScore

    console.log("You had " + playerScore + " compared to the dealer's " + dealerScore + ".")
    # dealer wins ties
    if playerScore > dealerScore then "You win." else "Dealer wins."

  promptPlayer: ->
    console.log "Okay, it's your turn now."
    (@get "playerHand").trigger "promptPlayer"

  promptDealer: ->
    (@get "dealerHand").trigger "promptDealer"
    console.log "It's the dealer's turn now."

