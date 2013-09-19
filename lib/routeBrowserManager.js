var define;

if (typeof define !== 'function') {
  define = require('amdefine')(module);
}

define(function(require) {
  var Route, RouteBrowserManage, _;
  Route = require('./route');
  _ = require('underscore');
  RouteBrowserManage = (function() {
    function RouteBrowserManage(routeMap) {
      this.routeMap = routeMap;
      this.route = new Route;
    }

    RouteBrowserManage.prototype.getRoute = function(name) {
      if (_.isObject(name)) {
        return name;
      }
      if (this.routeMap[name] == null) {
        throw new Error('route not found');
      }
      return this.routeMap[name];
    };

    RouteBrowserManage.prototype.is = function(route, name) {
      var r;
      r = this.getRoute(route);
      return this.route.is(r, name);
    };

    RouteBrowserManage.prototype.isSonOf = function(route, name) {
      var r;
      r = this.getRoute(route);
      return this.route.isSonOf(r, name);
    };

    RouteBrowserManage.prototype.getLink = function(route, attr) {
      var r;
      r = this.getRoute(route);
      return this.route.getLink(r, attr);
    };

    return RouteBrowserManage;

  })();
  return RouteBrowserManage;
});
