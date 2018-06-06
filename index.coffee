assert = require 'assert'
WordCount = require '../lib'
fs = require 'fs'
test1 = ''
test2 = ''
fs.readFile "#{__dirname}/fixtures/5,9,40.txt", 'utf8', (err, testData) ->
  test1 = testData
  if err then return cb err

fs.readFile "#{__dirname}/fixtures/3,7,46.txt", 'utf8', (err, testData) ->
  test2 = testData
  if err then return cb err
     
helper = (input, expected, done) ->
  pass = false
  counter = new WordCount()

  counter.on 'readable', ->
    return unless result = this.read()
    assert.deepEqual result, expected
    assert !pass, 'Are you sure everything works as expected?'
    pass = true

  counter.on 'end', ->
    if pass then return done()
    done new Error 'Looks like transform fn does not work'

  counter.write input
  counter.end()


describe '10-word-count', ->

  it 'running first test file', (done) ->
    input = test1
    expected = words: 9, lines: 5, chars: 40
    helper input, expected, done
  
  it 'running first test file', (done) ->
    input = test2
    expected = words: 7, lines: 3, chars: 46
    helper input, expected, done

  it 'check for words with special characters', (done) ->
    input = 'test test@'
    expected = words: 1, lines: 1, chars: 10
    helper input, expected, done

  it 'should count a single word', (done) ->
    input = 'test'
    expected = words: 1, lines: 1, chars: 4
    helper input, expected, done

  it 'should count words in a phrase', (done) ->
    input = 'this is a basic test'
    expected = words: 5, lines: 1, chars: 20
    helper input, expected, done

  it 'should count quoted characters as a single word', (done) ->
    input = '"this is one word!"'
    expected = words: 1, lines: 1, chars: 19
    helper input, expected, done
  
  it 'should count camel case characters as a multiple words', (done) ->
    input = 'this is CamelCase'
    expected = words: 4, lines: 1, chars: 17
    helper input, expected, done

  # !!!!!
  # Make the above tests pass and add more tests!
  # !!!!!
