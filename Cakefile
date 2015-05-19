kit = require 'nokit'

task 'test', 'test the tool', () ->
    kit.spawn 'mocha', [
        '-w'
        '--compilers'
        'coffee:coffee-script/register'
    ]
