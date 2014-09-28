#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  initialize: ->

    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()

    unless @has('score')
      @set 'score', [0,0]

      console.log("oooh setting the score")


    @get('playerHand').on 'playerBusted', =>
      console.log "You've busted! The dealer wins!"
      @incrementScore 1, 1
      @delayedReset()

    @get('dealerHand').on 'dealerBusted', =>
      console.log "The dealer has busted. You win!"
      @incrementScore 0,1
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

    if @get('dealerHand').hasBlackjack()
      console.log "Dealer has blackjack! Dealer wins."
      @get('dealerHand').at(0).flip()

      @delayedReset()

    else if @get('playerHand').hasBlackjack()
      console.log "You have blackjack!! You win!"
      @delayedReset()

    else
      @promptPlayer()


  delayedReset: ->
    setTimeout( =>
      @initialize({
        score : @get('score')
      })
      @trigger 'resetRender'
    ,1000)

  incrementScore: (index, change) ->
    (@get 'score')[index] += change

  determineWinner: (playerValues, dealerValues) ->
    # in this situation neither player has busted

    tooBig = (n) ->
      n > 21

    playerScore = Math.max( (_.reject playerValues, tooBig)... )
    dealerScore = Math.max( (_.reject dealerValues, tooBig)... )

    # when we're determining the winner, update the scores to the best score possible i.e. playerScore or dealerScore

    console.log("You had " + playerScore + " compared to the dealer's " + dealerScore + ".")
    # dealer wins ties

    out = null

    if playerScore > dealerScore
      out = "You win."
      @incrementScore 0, 1;
    else if dealerScore > playerScore
      out = "Dealer wins."
      @incrementScore 1, 1;
    else if (@get "playerHand").length is (@get "dealerHand").length
      out = "Push"
    else if (@get "playerHand").length > (@get "dealerHand").length
      out = "Values tied. Dealer wins based on length."
      @incrementScore 1, 1;
    else
      out = "Values tied. Player wins based on length."
      @incrementScore 0, 1;

    out

  promptPlayer: ->
    console.log "Okay, it's your turn now."
    (@get "playerHand").trigger "promptPlayer"

  promptDealer: ->
    (@get "dealerHand").trigger "promptDealer"
    console.log "It's the dealer's turn now."

