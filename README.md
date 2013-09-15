# Cameron Streams

[![Build Status](https://secure.travis-ci.org/evansolomon/cameron-streams.png?branch=master)](http://travis-ci.org/evansolomon/cameron-streams)

Like Cameron Frye in Ferris Bueller's Day Off, these streams will do whatever stupid thing you want them to. In practice, this can be helpful, especially when testing other streams.

> He'll keep calling me, he'll keep calling me until I come over. He'll make me feel guilty. This is uh... This is ridiculous, ok I'll go, I'll go, I'll go, I'll go, I'll go. What - I'LL GO. Shit.

&mdash; [Cameron Frye](https://www.youtube.com/watch?feature=player_detailpage&v=rIqWSPUh2rY#t=176)

## Install

You know the drill.

`npm install cameron-streams --save`

## Emitter

A writable stream that does nothing but emit `write` events when data is written. Each event has a `chunk` argument. Otherwise, written data is ignored.

```coffeescript
emitter = require('cameron-streams').emitter()
emitter.on 'write', (chunk) ->
  console.log chunk.toString()

emitter.write
"""
  I am not going to sit on my ass as the events that
  affect me unfold to determine the course of my life.
"""
# Prints Cameron's resolution
```

## Slow

A writable stream that handles data slowly. Set its delay in milliseconds when you create the stream.

```coffeescript
slow = require('cameron-streams').slow(100)

start = Date.now()
slow.write "Please don't say were not going to take the car home.", ->
  console.log Date.now() - start
  # Prints something close to 100
```

## Random

A readable stream that provides random bytes. Set how much data you want the stream to produce when you create the stream.

```coffeescript
fs = require 'fs'
random = require('cameron-streams').random(1024 * 1024)
random.pipe(fs.createWriteStream './output')

random.on 'end', ->
  console.log fs.statSync('./output').size
  # Prints 1,048,576 (1 mb)
```
