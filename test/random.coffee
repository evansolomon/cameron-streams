should = require 'should'
{Readable} = require 'stream'

cameron = require '../'

# Random and encoded streams should pass the same tests
for streamType in ['random', 'encoded']
  className = streamType.charAt(0).toUpperCase() + streamType.slice(1)
  stream = cameron[streamType]

  describe "#{className} Stream", ->
    describe 'Export', ->
      it 'Should be a function', ->
        stream.should.be.instanceof Function

    describe 'Readable stream', ->
      it 'Should be a readable stream', ->
        stream(0).should.be.instanceof Readable

      it 'Should pass options to parent', ->
        readable = stream 0, {highWaterMark: 100}
        readable._readableState.highWaterMark.should.equal 100

    describe 'Output chunks', ->
      it 'Should produce instances of Buffer', (done) ->
        readable = stream 100
        readable.on 'readable', ->
          readable.read().should.be.instanceof Buffer
          done()

      it 'Should respect encoding', (done) ->
        readable = stream 100
        readable.setEncoding 'utf8'

        readable.on 'readable', ->
          readable.read().should.be.a 'string'
          done()

      it 'Should produce the correct number of bytes', (done) ->
        numBytes = Math.floor Math.random() * 500000
        readable = stream numBytes

        dataRead = []

        readable.on 'end', ->
          Buffer.concat(dataRead).length.should.equal numBytes
          done()

        readable.on 'readable', ->
          while null != chunk = readable.read()
            dataRead.push chunk
