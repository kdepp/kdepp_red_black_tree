app = require '../app'
kit = require 'nokit'
_ = kit._
should = require 'should'
sinon = require 'sinon'
path = require 'path'

describe "app", () ->
    it "#first test", () ->
        true.should.equal true
