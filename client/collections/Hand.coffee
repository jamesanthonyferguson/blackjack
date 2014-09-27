class window.Hand extends Backbone.Collection

  model: Card

  # first argument to initialize is special, copies
  # the fields into the object you're creating
  # it's a backbone thing
  initialize: (array, @deck, @isDealer) ->

    # give the object an "acceptViewInput property"
    @acceptViewInput = false;
    @acceptDoubleDown = false;

    @on 'promptPlayer', ->
      @acceptViewInput = true
      @acceptDoubleDown = true;


    @on 'promptDealer', ->
      @dealerHit()

    @on 'hit', ->
      console.log "You hit."
      @hit()

    @on 'stood', ->
      console.log "You stand."
      @stand()

    @on 'double', ->
      console.log "You double down."
      @double()

  hasBlackjack: ->
    # only ever call at the beginning so
    # we only need to check the first two cards

    hasAce = @reduce (memo, card) ->
      memo or card.get('value') is 1
    , false

    # if we have an ace, the value sum should be 11.



    if hasAce
      foo = @at(0).get("value") + @at(1).get("value")
      return foo is 11
    else
      return false



  dealerHit: ->

    #if over 21, call dealer bust

    dealerCheck = =>
      if Math.min(@scores()...) > 21
        @dealerBust()
        return true

      #if between 17 and 21, trigger game complete (app can listen)

      if ((17 <= @scores()[0] <= 21) or (17 <= @scores()[1] <= 21) )
        @trigger 'gameComplete'
        return true

    dealerNewCard = =>
      out = @add(@deck.pop()).last()
      out

    repeater = =>
      b = dealerCheck()
      if not b
        dealerNewCard()
        setTimeout repeater, 1000

    @at(0).flip()
    b = dealerCheck()
    if not b
      setTimeout(repeater, 1000)

  double: ->
    @hit()
    if Math.min(@scores()...) < 22
      @stand()
    null

  hit: ->
    @acceptDoubleDown = false
    out = @add(@deck.pop()).last()
    if Math.min(@scores()...) > 21 then @bust()
    out


  stand: ->
    @acceptViewInput = false;

    tr = =>
      @trigger 'playerStood'

    setTimeout tr, 1000


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
    @trigger 'playerBusted'

  dealerBust: ->
    @trigger 'dealerBusted'
