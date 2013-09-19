# This adds the requirejs equivalent of define in node
if typeof define isnt 'function'
    define = require('amdefine')(module)

# module definition
define (require) ->
    class Route
        getRe: (route) ->
            parentRe = ''
            if route.parent?
                parentRe = @getRe route.parent
            return parentRe + route.re

        is: (route, name) ->
            return route.name == name

        isSonOf: (route, name) ->
            # See if is this object
            if @is route, name
                return true
            # If not, and haves a parent, delegage
            if route.parent?
                return @isSonOf route.parent, name
            # If we are at the top of the hierarchy, not much to do
            return false

        analizeRoute: (route) ->

            # Get regular expression
            route._fullRe = @getRe route

            # Initialize the route parameters
            route._parameters = []

            # This regexp matchs for :identifier(regexp)
            # Where identifier is a word, and regexp is a validation
            # for the identifier
            re =  /:(\w+)(?:\(([^\(]+)\))?/g

            while param = re.exec route._fullRe
                # If we have a match, the first parameter should be
                # there and its the indentifier name
                parameter =
                    name : param[1]

                # The second parameter should be a validation regexp
                if param[2]?
                    parameter.regexp = new RegExp '^'+param[2]+'$'

                # Add it in order in the parameter list
                route._parameters.push parameter

        getLink: (route, attr) ->

            if not route._parameters?
                @analizeRoute route

            ans = route._fullRe

            # If we have named parameters, replace them one by one using
            # the attr map
            re =  /:(\w+)(?:\(([^\(]+)\))?/
            for parameter in route._parameters
                # If we need it, and dont have it, return null
                if not attr[parameter.name]?
                    return null
                # If we have it, and doesnt pass the validation, return null
                if parameter.regexp? and not parameter.regexp.test attr[parameter.name]
                    return null

                # If we have it, replace it
                ans = ans.replace re, attr[parameter.name]

            return ans

    return Route