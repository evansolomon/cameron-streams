should = require 'should'
{Writable} = require 'stream'

{slow} = require '../'

describe 'Slow Stream', ->
  describe 'Export', ->
    it 'Should be a function', ->
      slow.should.be.instanceof Function

  describe 'Writable stream', ->
    it 'Should be a writable stream', ->
      slow(0).should.be.instanceof Writable

    it 'Should pass options to parent', ->
      writable = slow 0, {highWaterMark: 100}
      writable._writableState.highWaterMark.should.equal 100

  describe 'Slowness', ->
    it 'Should delay the write callback', (done) ->
      fasterWriteFinished = false

      slow(20).write "let my Cameron go!", ->
        fasterWriteFinished.should.be.ok
        done()

      slow(0).write "When Cameron was in Egypt's land...", ->
        fasterWriteFinished = true
