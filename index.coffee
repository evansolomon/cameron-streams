crypto = require 'crypto'
stream = require 'stream'

###
A readable stream that provides random bytes.

Set the total size of the random bytes provided across all "readable"
events with the `totalBytes` argument.
###
module.exports.RandomStream = class RandomStream extends stream.Readable
  constructor: (@totalBytes = 0, options) ->
    @bytesRead = 0
    super options

  generateRandomChunk: (size) ->
    crypto.randomBytes size

  _read: (size) ->
    size = Math.min size, @totalBytes - @bytesRead
    @bytesRead += size

    @push @generateRandomChunk size
    @push null if @bytesRead >= @totalBytes


###
A readable stream that provides random encoded characters. The encoding used
can be overriden by setting `instance.encoding`.

Set the total size of the random bytes provided across all "readable"
events with the `totalBytes` argument (see parent class).
###
module.exports.RandomEncodedStream = class RandomEncodedStream extends RandomStream
  encoding: 'hex'

  generateRandomChunk: (size) ->
    # Each random byte is encoded as two hex characters, so limit the output
    # to the expected size.
    #
    # Honestly, I just made this class so I could write `super(size)`
    super(size).toString(@encoding).slice 0, size


###
A Writable stream that emits "write" events for every write.

Each "write" event has a chunk argument (the data written).
###
module.exports.EmitterStream = class EmitterStream extends stream.Writable
  _write: (chunk, encoding, cb) ->
    @emit 'write', chunk
    cb()


###
A writable stream that ignores written data and delays the write callback.

Set the callback delay with the `timeout` argument.
###
module.exports.SlowStream = class SlowStream extends stream.Writable
  constructor: (@timeout = 0, options) ->
    super options

  _write: (chunk, encoding, cb) ->
    setTimeout cb, @timeout


# Export the streams
module.exports.random = (size, options) ->
  new RandomStream size, options

module.exports.encoded = (size, options) ->
  new RandomEncodedStream size, options

module.exports.emitter = (options) ->
  new EmitterStream options

module.exports.slow = (timeout, options) ->
  new SlowStream timeout, options
