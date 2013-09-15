should = require 'should'
{Readable} = require 'stream'

{random} = require '../'

describe 'Random Stream', ->
  describe 'Export', ->
    it 'Should be a function', ->
      random.should.be.instanceof Function

  describe 'Readable stream', ->
    it 'Should be a readable stream', ->
      random(0).should.be.instanceof Readable

    it 'Should pass options to parent', ->
      readable = random 0, {highWaterMark: 100}
      readable._readableState.highWaterMark.should.equal 100

  describe 'Output chunks', ->
    it 'Should produce instances of Buffer', (done) ->
      readable = random 100
      readable.on 'readable', ->
        readable.read().should.be.instanceof Buffer
        done()

    it 'Should respect encoding', (done) ->
      readable = random 100
      readable.setEncoding 'utf8'

      readable.on 'readable', ->
        readable.read().should.be.a 'string'
        done()

    it 'Should produce the correct number of bytes', (done) ->
      numBytes = 500000
      readable = random numBytes

      dataRead = []

      readable.on 'end', ->
        Buffer.concat(dataRead).length.should.equal numBytes
        done()

      readable.on 'readable', ->
        while null != chunk = readable.read()
          dataRead.push chunk
