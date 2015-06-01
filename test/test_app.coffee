Rbt = require '../app'
kit = require 'nokit'
_ = kit._
should = require 'should'
sinon = require 'sinon'
path = require 'path'
beautify = require('js-beautify').js_beautify

json_log = (json) -> console.log beautify(JSON.stringify(json))
node_log = (node) -> json_log remove_parent(node)

remove_cache = {}

remove_parent = (node) ->
    node.left?.parent = undefined
    node.right?.parent = undefined

    remove_cache[node.value] = 1 + (remove_cache[node.value] || 0)
    #console.log remove_cache

    if node.left
        remove_parent node.left

    if node.right
        remove_parent node.right

    node

{BLACK, RED} = Rbt

describe "red black tree", () ->
    describe "#first node", () ->
        tree = null

        beforeEach () ->
            tree = new Rbt
            tree.add 100

        it "#add", () ->
            tree.root.value.should.equal 100
            tree.root.color.should.equal BLACK
            Rbt.check_leaf(tree.root.left).should.be.true
            Rbt.check_leaf(tree.root.right).should.be.true

        it "#search 100", () ->
            ret = tree.search 100
            Rbt.check_leaf(ret).should.be.false
            ret.value.should.eql 100

        it "#search 10", () ->
            ret = tree.search 10
            Rbt.check_leaf(ret).should.be.true

    describe "#second node", () ->
        tree = null

        beforeEach () ->
            tree = new Rbt
            tree.add 100
            tree.add 10
            tree.add 200

        it "#add", () ->
            tree.root.left.value.should.equal 10
            tree.root.left.color.should.equal RED

            tree.root.right.value.should.equal 200
            tree.root.right.color.should.equal RED

        it "#search 10", () ->
            ret = tree.search 10
            ret.value.should.eql 10

        it "#search 200", () ->
            ret = tree.search 200
            ret.value.should.eql 200

        it "#search 11", () ->
            ret = tree.search 11
            Rbt.check_leaf(ret).should.be.true


    describe "#multiple nodes", () ->

        describe "#10, 9, 8", () ->
            tree = new Rbt
            _.each [10, 9, 8], (x) -> tree.add x

            it "#root is 9, and it's black", () ->
                tree.root.value.should.eql 9
                tree.root.color.should.eql BLACK

            it "#9's parent is null", () ->
                (null == tree.root.parent).should.be.true

            it "#root.left is 8, and it's red", () ->
                tree.root.left.value.should.eql 8
                tree.root.left.color.should.eql RED

            it "#root.right is 10, and it's red", () ->
                tree.root.right.value.should.eql 10
                tree.root.right.color.should.eql RED

        describe "#10, 9, 8, 7, 6", () ->
            tree = new Rbt
            _.each [10, 9, 8, 7, 6], (x) -> tree.add x

            it "#root is 9, and it's black", () ->
                tree.root.value.should.eql 9
                tree.root.color.should.eql BLACK

            it "#root's left is 7, and it's black", () ->
                tree.root.left.value.should.eql 7
                tree.root.left.color.should.eql BLACK

            it "#root's right is 10, and it's black", () ->
                tree.root.right.value.should.eql 10
                tree.root.right.color.should.eql BLACK

            it "#6 is red, and its parent is 7", () ->
                ret = tree.search 6
                ret.color.should.eql RED
                ret.parent.value.should.eql 7

            it "#8 is red, and its parent is 7", () ->
                ret = tree.search 8
                ret.color.should.eql RED
                ret.parent.value.should.eql 7


        describe "#6, 7, 8, 9, 10", () ->
            tree = new Rbt
            _.each [6, 7, 8, 9, 10], (x) -> tree.add x

            it "#root is 7, and it's black", () ->
                tree.root.value.should.eql 7
                tree.root.color.should.eql BLACK

            it "#root's left is 6, and it's black", () ->
                tree.root.left.value.should.eql 6
                tree.root.left.color.should.eql BLACK

            it "#root's right is 9, and it's black", () ->
                tree.root.right.value.should.eql 9
                tree.root.right.color.should.eql BLACK

            it "#8 is red, and its parent is 9", () ->
                ret = tree.search 8
                ret.color.should.eql RED
                ret.parent.value.should.eql 9

            it "#10 is red, and its parent is 9", () ->
                ret = tree.search 10
                ret.color.should.eql RED
                ret.parent.value.should.eql 9


        describe "#100, 80, 60, 40, 20, 10, 15", () ->
            tree = new Rbt
            _.each [100, 80, 60, 40, 20, 10, 15], (x) -> tree.add x

            it "#root is 80, and it's black", () ->
                tree.root.value.should.equal 80
                tree.root.color.should.equal BLACK

            it "#80's left is 40, and it's red", () ->
                tree.root.left.value.should.equal 40
                tree.root.left.color.should.equal RED

            it "#80's right is 100, and it's black", () ->
                tree.root.right.value.should.equal 100
                tree.root.right.color.should.equal BLACK

            it "#15's left is 10, and it's black", () ->
                ret = tree.search 15
                ret.left.value.should.equal 10
                ret.left.color.should.equal RED

            it "#15's right is 20, and it's black", () ->
                ret = tree.search 15
                ret.right.value.should.equal 20
                ret.right.color.should.equal RED

            it "#40 is red, and its parent is 20", () ->
                ret = tree.search 40
                ret.color.should.equal RED
                ret.parent.value.should.equal 80


        describe.skip "#4, 7, 12, 15, 3, 5, 14, 18, 16, 17", () ->
            tree = new Rbt

            _.each [4, 7, 12, 15, 3, 5, 14, 18, 16, 17].slice(0, 10), (x) -> tree.add x

            it "d", () ->
                true.should.equal true


    describe "#removeal", () ->
        
        describe "#remove 3, simple remove", () ->
            tree = new Rbt
            _.each [4, 7, 12, 15, 3, 5, 14, 18, 16, 17].slice(0, 10), (x) -> tree.add x
            tree.remove 3
            ret = tree.search 4
        
            it "#4's left is leaf", () ->
                Rbt.check_leaf(ret.left).should.equal true

            it "#4's right is still 5", () ->
                ret.right.value.should.equal 5
            
            it "#4's parent is still 7", () ->
                ret.parent.value.should.equal 7

            it "#7's left is still 4", () ->
                #console.log(require('util').inspect((tree.search 7), true, 10))
                (tree.search 7).left.value.should.equal 4


        describe "#remove 12, restructing, sibling has on red child", () ->
            tree = new Rbt
            _.each [4, 7, 12, 15, 3, 5, 14, 18, 16, 17].slice(0, 10), (x) -> tree.add x
            tree.remove 3
            tree.remove 12
            ret = tree.search 5

            it "#5's color is red, its parent is 14", () ->
                ret.color.should.equal RED
                ret.parent.value.should.equal 14

            it "#5's left is 4 and it's black", () ->
                ret.left.value.should.equal 4
                ret.left.color.should.equal BLACK
            
            it "#5's right is 4 and it's black", () ->
                ret.right.value.should.equal 7
                ret.right.color.should.equal BLACK
        
        describe "#remove 17, simple remove", () ->
            tree = new Rbt
            _.each [4, 7, 12, 15, 3, 5, 14, 18, 16, 17].slice(0, 10), (x) -> tree.add x
            tree.remove 3
            tree.remove 12
            tree.remove 17
            ret = tree.search 18

            it "#18's both children is leaf, and its parent is still 16, red", () ->
                (Rbt.check_leaf ret.left).should.equal true
                (Rbt.check_leaf ret.right).should.equal true
                ret.parent.value.should.equal 16
                ret.parent.color.should.equal RED

        describe "#remove 18, recoloring", () ->
            tree = new Rbt
            _.each [4, 7, 12, 15, 3, 5, 14, 18, 16, 17].slice(0, 10), (x) -> tree.add x
            tree.remove 3
            tree.remove 12
            tree.remove 17
            tree.remove 18
            ret = tree.search 16

            it "#16 changed to black, and its parent is still 14", () ->
                ret.color.should.equal BLACK
                ret.parent.value.should.equal 14

            it "#16'sleft is still 15, but changed to RED", () ->
                ret.left.value.should.equal 15
                ret.left.color.should.equal RED

        describe "#remove 15, simple remove", () ->
            tree = new Rbt
            _.each [4, 7, 12, 15, 3, 5, 14, 18, 16, 17].slice(0, 10), (x) -> tree.add x
            tree.remove 3
            tree.remove 12
            tree.remove 17
            tree.remove 18
            tree.remove 15
            ret = tree.search 16

            it "#16's both children is leaf, and its parent is still 16, red", () ->
                (Rbt.check_leaf ret.left).should.equal true
                (Rbt.check_leaf ret.right).should.equal true
                ret.parent.value.should.equal 14
                ret.parent.color.should.equal BLACK

        describe "#remove 16, recoloring", () ->
            tree = new Rbt
            _.each [4, 7, 12, 15, 3, 5, 14, 18, 16, 17].slice(0, 10), (x) -> tree.add x
            tree.remove 3
            tree.remove 12
            tree.remove 17
            tree.remove 18
            tree.remove 15
            tree.remove 16
            ret = tree.search 16

            it "#root is 5", () ->
                tree.root.value.should.equal 5
                tree.root.color.should.equal BLACK

            it "#root's left is 4", () ->
                tree.root.left.value.should.equal 4
                tree.root.left.color.should.equal BLACK

            it "#root's right is 14", () ->
                tree.root.right.value.should.equal 14
                tree.root.right.color.should.equal BLACK

            it "#14's left is 7, right is leaf", () ->
                tree.root.right.left.value.should.equal 7
                tree.root.right.left.color.should.equal RED
                (Rbt.check_leaf tree.root.right.right).should.equal true

