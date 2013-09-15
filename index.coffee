crypto = require 'crypto'
stream = require 'stream'

###
A readable stream that provides random bytes.

Set the total size of the random bytes provided across all "readable"
events with the `totalBytes` argument.
###
class RandomStream extends stream.Readable
  constructor: (@totalBytes = 0, options) ->
    @bytesRead = 0
    super options

  _read: (size) ->
    size = Math.min size, @totalBytes - @bytesRead
    @bytesRead += size

    @push crypto.randomBytes size
    @push null if @bytesRead >= @totalBytes


###
A Writable stream that emits "write" events for every write.

Each "write" event has a chunk argument (the data written).
###
class EmitterStream extends stream.Writable
  constructor: (options) ->
    super options

  _write: (chunk, encoding, cb) ->
    @emit 'write', chunk
    cb()


###
A writable stream that ignores written data and delays the write callback.

Set the callback delay with the `timeout` argument.
###
class SlowStream extends stream.Writable
  constructor: (@timeout = 0, options) ->
    super options

  _write: (chunk, encoding, cb) ->
    setTimeout cb, @timeout


# Export the streams
module.exports =
  random: (size, options) ->
    new RandomStream size, options

  emitter: (options) ->
    new EmitterStream options

  slow: (timeout, options) ->
    new SlowStream timeout, options
