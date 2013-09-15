should = require 'should'
{Writable} = require 'stream'
{EventEmitter} = require 'events'

{emitter} = require '../'

describe 'Emitter Stream', ->
  describe 'Export', ->
    it 'Should be a function', ->
      emitter.should.be.instanceof Function

  describe 'Event emitter', ->
    it 'Should be an EventEmitter', ->
      emitter().should.be.instanceof EventEmitter

  describe 'Writable stream', ->
    it 'Should be a writable stream', ->
      emitter().should.be.instanceof Writable

    it 'Should pass options to parent', ->
      writable = emitter {highWaterMark: 100}
      writable._writableState.highWaterMark.should.equal 100

  describe 'Emitted events', ->
    it 'Should emit "write" events', (done) ->
      dontLie = "You're not dying, you just can't think of anything good to do."
      writable = emitter()

      writable.on 'write', (chunk) ->
        chunk.toString().should.equal dontLie
        done()

      writable.write dontLie
