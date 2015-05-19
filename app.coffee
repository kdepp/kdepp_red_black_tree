kit = require 'nokit'
_ = kit._

BLACK = 0
RED = 1


class Node

    left: null

    right: null

    value: undefined

    color: BLACK

    constructor: (is_leaf, val, is_black) ->
        return @ if is_leaf

        @value = val
        @color = ~~!is_black
        @left = new Node true
        @right = new Node true

        @


class RedBlackTree

    @BLACK: BLACK

    @RED: RED

    @check_leaf: (node) ->
        node.left == null && node.right == null && node.value == undefined

    compare: () ->

    root: new Node true

    constructor: (opts) ->
        @compare = opts?.compare || (a, b) ->
            return 0 if a == b
            return 1 if a > b
            return -1

    add: (val) ->
        node = new Node false, val

        if RedBlackTree.check_leaf @root
            @root = node
            @root.color = BLACK

    remove: (val) ->

    search: (val) ->
        node = @root

        while !RedBlackTree.check_leaf(node)
            result = @compare val, node.value
            return node if result == 0
            node = node[if result == 1 then 'right' else 'left']

        return null


module.exports = RedBlackTree
