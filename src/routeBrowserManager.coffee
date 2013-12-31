class RouteBrowserManager
    constructor: (@routeMap) ->
        @route = new Route

    getRoute: (name) ->
        if typeof name is "object"
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

    getLink: (route, attr={}) ->
        r = @getRoute route
        @route.getLink r, attr

    getRe: (route) ->
        r = @getRoute route
        @route.getRe r

    getParameters: (route) ->
        r = @getRoute route
        @route.getParameters r


