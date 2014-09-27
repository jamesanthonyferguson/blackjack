assert = chai.assert

describe 'Hand', ->

  deck = null
  hand = null

  it 'should create blank hand', ->
    deck = new Deck()
    # new hand, not dealer
    hand = new Hand [], deck, false

    assert.strictEqual hand.length, 0
    assert.strictEqual hand.isDealer, no

  it 'should grow when a card is added', ->

    deck = new Deck()
    # new hand, not dealer
    hand = new Hand [], deck, false

    hand.hit()
    assert.strictEqual hand.length, 1;
    assert.strictEqual deck.length, 51;

  it 'should correctly know value', ->
    hand = new Hand([])

    hand.add new Card
      suit : 0
      rank : 1

    assert.deepEqual hand.scores(), [1,11];

  it 'player should allow input when prompted, but deny after stand', ->
    deck = new Deck()
    hand = new Hand [], deck, false

    assert.strictEqual hand.acceptViewInput, false
    hand.trigger 'promptPlayer'
    assert.strictEqual hand.acceptViewInput, true
    hand.trigger 'stood'
    assert.strictEqual hand.acceptViewInput, false
