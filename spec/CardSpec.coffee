assert = chai.assert

describe 'card', ->

  card = null # declare card, make it visible to all tests

  describe 'Ace of Spades', ->

    beforeEach ->
      card = new Card
        suit : 0
        rank : 1

    it 'should create Ace of Spades', ->

      assert.strictEqual card.get("suitName"), "Spades"
      assert.strictEqual card.get("rankName"), "Ace"

    it 'flipping ace of spades should flip ace of spades', ->
      assert.strictEqual card.get("revealed"), true
      card.flip()
      assert.strictEqual card.get("revealed"), false

    it 'should have a value of 1', ->
      assert.strictEqual card.get("value"), 1

  describe 'face cards', ->
    it 'face cards should have correct value', ->
      faceCards = (new Card {rank : x, suit : 0} for x in [0,11,12] )
      for card in faceCards
        assert.strictEqual card.get("value"), 10
        assert.strictEqual card.get("suitName"), "Spades"


