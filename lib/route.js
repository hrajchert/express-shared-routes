(function(root, factory) {
    if(typeof exports === 'object') {
        module.exports = factory();
    }
    else if(typeof define === 'function' && define.amd) {
        define('Route', [], factory);
    }
    else {
        root.Route = factory();
    }
}(this, function() {
var Route;

Route = (function() {
  function Route() {}

  Route.prototype.getRe = function(route) {
    var parentRe;
    parentRe = '';
    if (route.parent != null) {
      parentRe = this.getRe(route.parent);
    }
    return parentRe + route.re;
  };

  Route.prototype.is = function(route, name) {
    return route.name === name;
  };

  Route.prototype.isSonOf = function(route, name) {
    if (this.is(route, name)) {
      return true;
    }
    if (route.parent != null) {
      return this.isSonOf(route.parent, name);
    }
    return false;
  };

  Route.prototype.analizeRoute = function(route) {
    var param, parameter, re, _results;
    route._fullRe = this.getRe(route);
    route._parameters = [];
    re = /:(\w+)(?:\(([^\(]+)\))?/g;
    _results = [];
    while (param = re.exec(route._fullRe)) {
      parameter = {
        name: param[1]
      };
      if (param[2] != null) {
        parameter.regexp = new RegExp('^' + param[2] + '$');
      }
      _results.push(route._parameters.push(parameter));
    }
    return _results;
  };

  Route.prototype.getParameters = function(route) {
    if (route._parameters == null) {
      this.analizeRoute(route);
    }
    return route._parameters;
  };

  Route.prototype.getLink = function(route, attr) {
    var ans, parameter, re, _i, _len, _ref;
    if (route._parameters == null) {
      this.analizeRoute(route);
    }
    ans = route._fullRe;
    re = /:(\w+)(?:\(([^\(]+)\))?/;
    _ref = route._parameters;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      parameter = _ref[_i];
      if (attr[parameter.name] == null) {
        return null;
      }
      if ((parameter.regexp != null) && !parameter.regexp.test(attr[parameter.name])) {
        return null;
      }
      ans = ans.replace(re, attr[parameter.name]);
    }
    return ans;
  };

  return Route;

})();

    return Route;
}));
