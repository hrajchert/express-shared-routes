(function(root, factory) {
    if(typeof exports === 'object') {
        module.exports = factory(require('Route'));
    }
    else if(typeof define === 'function' && define.amd) {
        define('RouteManager', ['Route'], factory);
    }
    else {
        root.RouteManager = factory(root.Route);
    }
}(this, function(Route) {
var RouteBrowserManager;

RouteBrowserManager = (function() {
  function RouteBrowserManager(routeMap) {
    this.routeMap = routeMap;
    this.route = new Route;
  }

  RouteBrowserManager.prototype.getRoute = function(name) {
    if (typeof name === "object") {
      return name;
    }
    if (this.routeMap[name] == null) {
      throw new Error('route not found');
    }
    return this.routeMap[name];
  };

  RouteBrowserManager.prototype.is = function(route, name) {
    var r;
    r = this.getRoute(route);
    return this.route.is(r, name);
  };

  RouteBrowserManager.prototype.isSonOf = function(route, name) {
    var r;
    r = this.getRoute(route);
    return this.route.isSonOf(r, name);
  };

  RouteBrowserManager.prototype.getLink = function(route, attr) {
    var r;
    if (attr == null) {
      attr = {};
    }
    r = this.getRoute(route);
    return this.route.getLink(r, attr);
  };

  return RouteBrowserManager;

})();

    return RouteBrowserManager;
}));
