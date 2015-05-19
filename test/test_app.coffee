Rbt = require '../app'
kit = require 'nokit'
_ = kit._
should = require 'should'
sinon = require 'sinon'
path = require 'path'

{BLACK, RED} = Rbt


describe "app", () ->
    describe "#first node", () ->
        tree = null

        beforeEach () ->
            tree = new Rbt
            tree.add 100

        it "add", () ->
            tree.root.value.should.equal 100
            tree.root.color.should.equal BLACK
            Rbt.check_leaf(tree.root.left).should.be.true
            Rbt.check_leaf(tree.root.right).should.be.true

        it "search", () ->
            ret = tree.search(100)
            ret.should.not.be.null
            ret.value.should.eql 100

            ret = tree.search(10)
            (ret == null).should.be.true
            
        
