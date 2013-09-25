_ = require 'underscore'
Route = require './route'

class RouteManager
    # This is an ordered list of the routes to insert into express app routes using the method applyRoutes.
    # You can insert duplicate routes, this is not validated. In fact, it is expected, so you can call the same
    # route with different verbs, for example 'get /edit' to get an edit form and 'put /edit' to actually submit it
    # In this object, the importance is given to the verb (get, put, post, all) and the callbacks
    routeList: []

    # This is an unordered map of the routes, it is used in conjunction with getRoute, which will be used for
    # the creation of links between the website.
    # The key of the map is the name of the route, so only one route will be stored when multiple verbs are provided.
    # In this object, the importance is to the name and regexp, the verb is not important
    routeMap: {}

    constructor: (@options) ->
        @route = new Route

    clear: () ->
        @routeList = []
        @routeMap = {}

    exportRoutes: () ->
        @routeMap

    getRoute: (name) ->
        if _.isObject name
            return name

        if not @routeMap[name]?
            throw new Error 'Route ' + name + ' was not found'

        @routeMap[name]

    applyRoutes: (expressApp) ->
        for r in @routeList
            # create the arguments to call app.VERB
            # The list goes: re, and then the callback(s)
            args = [@route.getRe(r), r.cb]
            expressApp[r.method].apply expressApp, args

    get: (route, cb...) ->
        @verb 'get', route, cb

    put: (route, cb...) ->
        @verb 'put', route, cb

    post: (route, cb...) ->
        @verb 'post', route, cb

    all: (route, cb...) ->
        @verb 'all', route, cb

    verb: (method, route, cb) ->
        # Store a clone of the route unmodified in the routeMap
        @routeMap[route.name] = _.clone route

        # clone the route to modify it and insert it in the route list
        r = _.clone route

        # If some callbacks where supplied, replace them
        if cb.length > 0
            r.cb = cb
        else
            # If not, lets create the final cb

            # If r.cb is a function, convert it to a one element array
            if r.cb? and _.isFunction r.cb
                r.cb = [r.cb]

            # If we have a handler, lets build our cb from that (will override previous cb)
            if r.handler? and _.isFunction r.handler
                # If mw is defined, thats the base of our new cb
                if r.mw?
                    # If the mw (middleware) its a function, convert it to a one element array
                    if _.isFunction r.mw
                        r.cb = [r.mw]
                    # If its an array, smush it right there
                    else if _.isArray r.mw
                        r.cb = r.mw
                    else
                        throw new Error 'Invalid middleware type'
                else
                    # If mw is not defined, we asume empty middleware
                    r.cb = []

                # If we are here, then r.cb is an array with the middleware, if any, lets add our handler
                r.cb.push r.handler


        # Throw an error if we end up with no cb
        if not r.cb? or not _.isArray(r.cb) or r.cb.length == 0
            throw new Error 'Invalid callback supplied'

        # See if want to inject in the request the matched route
        if @options? and @options.injectToLocals?
            @injectToLocals r

        # Indicate what method we will be using
        r.method = method

        @routeList.push r

    injectToLocals: (route) ->
        reqVar = @options.injectToLocals
        # Add a middleware as the first cb
        route.cb.unshift (req, res, next) ->
            res.locals[reqVar] = route
            next()

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


module.exports = RouteManager