class window.Hand extends Backbone.Collection

  model: Card

  # first argument to initialize is special, copies
  # the fields into the object you're creating
  # it's a backbone thing
  initialize: (array, @deck, @isDealer) ->

    # give the object an "acceptViewInput property"
    @acceptViewInput = false;

    @on 'promptPlayer', ->
      console.log "undefined is bullshit its true"

      @acceptViewInput = true

      console.log @acceptViewInput

    @on 'promptDealer', ->
      console.log("prompting Dealer")
      @dealerHit()

    @on 'hit', ->
      console.log "hit"
      @hit()

    @on 'stood', ->
      console.log "stood"
      @stand()


  dealerHit: ->

    console.log("starting dealerHit")

    #if over 21, call dealer bust

    console.log(@scores())

    if Math.min(@scores()...) > 21
      @dealerBust()
      console.log("dealerbust")
      return

    #if between 17 and 21, trigger game complete (app can listen)

    if ((17 <= @scores()[0] <= 21) or (17 <= @scores()[1] <= 21) )
      @trigger 'gameComplete'
      console.log("game over. somebody won")
      return

    out = @add(@deck.pop()).last()

    console.log("setting timeout")

    repeater = => @dealerHit()
    setTimeout repeater, 1000


    out




  hit: ->
    out = @add(@deck.pop()).last()
    if Math.min(@scores()...) > 21 then @bust()
    out


  stand: ->
    @acceptViewInput = false;
    @trigger 'playerStood'


  scores: ->
    # The scores are an array of potential scores.
    # Usually, that array contains one element. That is the only score.
    # when there is an ace, it offers you two scores - the original score, and score + 10.

    # bullshit way to check if there's an ace in here using
    # reduce instead of contains - also doesn't account fore more than one ace
    hasAce = @reduce (memo, card) ->
      memo or card.get('value') is 1
    , false

    # this is just bad. but you can't count two aces as 11
    # simultaneously, so there are only ever at most 2 potential values
    score = @reduce (score, card) ->
      score + if card.get 'revealed' then card.get 'value' else 0
    , 0
    if hasAce then [score, score + 10] else [score]

  bust: ->
    @acceptViewInput = false
    console.log "player busted"
    @trigger 'playerBusted'

  dealerBust: ->
    console.log "dealer busted"
    @trigger 'dealerBusted'
