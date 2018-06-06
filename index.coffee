through2 = require 'through2'


module.exports = ->
  words = 0
  lines = 0
  chars = 0
  regex = /^[a-zA-Z0-9]+$/

  transform = (chunk, encoding, cb) ->
    chars = chunk.length
    chunk = chunk.trim '\n'
    lineTokens = chunk.split('\n')
    lines = lineTokens.length
    chunk = chunk.replace /[\r\n]+/g, " "
    chunk = chunk.replace /\"(.+?)\"/g, 'dummyword'
    chunk = chunk.replace /([a-z](?=[A-Z]))/g, '$1 '
    # chunk = chunk.replace(/^\s*\n/gm, "")
    tokens = chunk.split(' ')
    for token in tokens when token
      if regex.test(token) then words++
    return cb()

  flush = (cb) ->
    this.push {words, lines, chars}
    this.push null
    return cb()

  return through2.obj transform, flush
