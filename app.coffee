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

    destruct: () ->
        @value = null
        @color = null
        @left = null
        @right = null
        @parent = null


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
        node = @search val
        return if RedBlackTree.check_leaf node

        nearest = @_remove_node node
        @_adjust_double_black nearest.node, nearest.last_color


    search: (val) ->
        {node} = @_search val
        node

    _search: (val, till_leaf) ->
        node = @root
        last = null

        while !RedBlackTree.check_leaf(node)
            result = @compare val, node.value
            return {last, node} if !till_leaf && result == 0
            last = node
            node = node[if result == 1 then 'right' else 'left']

        return {last, node}

    _set_child: (parent, node, is_left) ->
        parent[if is_left then 'left' else 'right'] = node
        node.parent = parent

    _set_root: (node) ->
        @root = node
        node.parent = null

    _remove_node: (node) ->
        one = if !RedBlackTree.check_leaf node.left then node.left else node.right
        opposite = {
            left: 'right'
            right: 'left'
        }
        direction = if node.left == one then 'right' else 'left'
        last = one
        ret = null
        last_color = null

        while !RedBlackTree.check_leaf one
            last = one
            one = one[direction]

        # remove the node
        # set double black on leaf
        if node == @root && one == last
            @root = new Node true
            return null

        if one == last
            last = node
            ret = new Node true
        else
            ret = last[opposite[direction]]

        node.value = last.value
        last_color = last.color

        @_set_child last.parent, ret, last == last.parent.left
        last.destruct()
            
        return {node: ret, last_color}

    _adjust_double_black: (node, last_color) ->
        return if !node

        if node.color == RED || last_color == RED
            node.color = BLACK
            return


        # if it's not red, then it's double black
        n = node
        p = n.parent
        g = p.parent

        p_is_root = p == @root
        p_is_left = p_is_root || p == g.left
        n_is_left = n == p.left
        s_is_left = !n_is_left

        s = n.parent[if n_is_left then 'right' else 'left']

        if s.color == RED
            # adjustment needed here
            @_set_child p, s[if s_is_left then 'right' else 'left'], s_is_left
            @_set_child s, p, !s_is_left

            p.color = RED
            s.color = BLACK

            if p_is_root
                @_set_root s
            else
                @_set_child g, s, p_is_left

            # after restructing, call it on node n again
            @_adjust_double_black n, BLACK
        else
            # s cannot be a leaf, or it will break the rule before the whole removal
            # scr: sibling's red child
            scr = null

            if s.left.color == RED
                scr = s.left
            else if s.right.color == RED
                scr = s.right

            if scr == null
                # sibling has no red child => recoloring
                s.color = RED

                if p.color == RED
                    p.color = BLACK
                else
                    # propogated, now p is double black, call it again
                    @_adjust_double_black p, BLACK
            else
                # one red child => restructing
                p_color = p.color
                {min, mid, max} = @_mid p, s, scr

                if mid == scr
                    @_set_child min, mid[if s_is_left  then 'left' else 'right'], !s_is_left
                    @_set_child max, mid[if !s_is_left then 'left' else 'right'], s_is_left
                    @_set_child mid, min, true
                    @_set_child mid, max, false
                else if mid == s
                    @_set_child p, s[if s_is_left then 'right' else 'left'], s_is_left
                    @_set_child s, p, !s_is_left

                min.color = BLACK
                max.color = BLACK
                mid.color = p_color

                if p_is_root
                    mid.color = BLACK
                    @_set_root mid
                else
                    @_set_child g, mid, p_is_left

        

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
