BLACK = 0
RED = 1

class Node

    left: null

    right: null

    parent: null

    value: undefined

    color: BLACK

    constructor: (is_leaf, val, is_black) ->
        if is_leaf
            @color = BLACK
            @tag = 'leaf'
            return @

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
        one = new Node false, val

        if RedBlackTree.check_leaf @root
            @root = one
            @root.color = BLACK
            return one

        {last, node} = @_search val, true
        one.color = RED

        @_set_child last, one, @compare(val, last.value) <= 0
        @_adjust_double_red one

        one

    remove: (val) ->

    search: (val) ->
        {node} = @_search val
        node

    _search: (val, not_till_leaf) ->
        node = @root
        last = null

        while !RedBlackTree.check_leaf(node)
            result = @compare val, node.value
            return {last, node} if !not_till_leaf && result == 0
            last = node
            node = node[if result == 1 then 'right' else 'left']

        return {last, node}

    _set_child: (parent, node, is_left) ->
        parent[if is_left then 'left' else 'right'] = node
        node.parent = parent

    _set_root: (node) ->
        @root = node
        node.parent = null

    _mid: (a, b, c) ->
        list = [a, b, c].sort (x, y) =>
            @compare x.value, y.value

        {
            min: list[0]
            mid: list[1]
            max: list[2]
        }

    _adjust_double_red: (node) ->
        if node == @root
            node.color = BLACK
            return

        if node.color == RED && node.parent.color == RED
            n = node
            p = n.parent
            g = p.parent
            gg = g.parent

            n_is_left = n == p.left
            p_is_left = p == g.left
            g_is_root = g == @root
            g_is_left = gg?.left == g

            ps = g[if p_is_left then 'right' else 'left']

            if ps.color == RED
                p.color = BLACK
                ps.color = BLACK
                g.color = RED

                @_adjust_double_red g
            else
                {min, mid, max} = @_mid n, p, g

                if mid == n
                    @_set_child min, mid[if n_is_left then 'left' else 'right'], !n_is_left
                    @_set_child max, mid[if n_is_left then 'right' else 'left'], n_is_left
                    @_set_child mid, min, true
                    @_set_child mid, max, false
                else if mid == p
                    @_set_child g, mid[if p_is_left then 'right' else 'left'], p_is_left
                    @_set_child mid, g, !p_is_left

                min.color = RED
                max.color = RED
                mid.color = BLACK

                if g_is_root
                    @_set_root mid
                else
                    @_set_child gg, mid, g_is_left


module.exports = RedBlackTree
