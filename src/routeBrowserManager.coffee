# This adds the requirejs equivalent of define in node
if typeof define isnt 'function'
    define = require('amdefine')(module)

# module definition
define (require) ->
    Route = require './route'
    _ = require 'underscore'

    # Define the user class
    class RouteBrowserManage
        constructor: (@routeMap) ->
            @route = new Route

        getRoute: (name) ->
            if _.isObject name
                return name
            if not @routeMap[name]?
                throw new Error 'route not found'
            @routeMap[name]

        #
        # Facade methods for route
        #
        is: (route, name) ->
            r = @getRoute route
            @route.is r, name

        isSonOf: (route, name) ->
            r = @getRoute route
            @route.isSonOf r, name

        getLink: (route, attr) ->
            r = @getRoute route
            @route.getLink r, attr


    # The value returned from the function is
    # used as the module export visible to Node and requirejs.
    return RouteBrowserManage

