# Express Shared Routes

> Named routes for the express framework that are shared between the server and the browser.

This is a minimalistic library (around 200 lines of code) that allows you to softcode your routes and ease the creation of navigation components like menus and breadcrums. The routes are normally defined in the server and can be exported to the browser (if you need client side rendering of links). The library has no dependencies in the browser, weights 370 Bytes gziped and is coded using a [UMD](https://github.com/umdjs/umd) pattern, so you can use it directly or with [RequireJS](http://requirejs.org/).

#### Name your routes

So, your routes probably look something like this

```js
// Normal express Route
app.get('/hello', function(req, res){
    res.send('hello world');
});
```

The library allows you to add a name to your routes, so you can easily reference them.

```js
// Our way
routes.get({name: "hello", re: '/hello'}, function(req, res){
    res.send('hello world');
});
```

The routes are Javascript <i>Object Literals</i>, that must have at least a name, and a regular expresion (re).


#### Create links

Instead of using hardcoded links like this `var href = '/hello/' + name`, you can reference a named route, and pass parameters to it. The parameter definition comes from the express route definition.

```js
routes.get({name: "named-hello", re: '/hello/:name'}, function(req, res){
    // Soft coded link
    var href = routes.getLink ('named-hello', {name: 'Handsome'});

    var response = "Hello " + req.param('name');
    response += " <a href='"+ href + "'>Link</a>";
    res.send(response);
});
```

Notice that `getLink` is using the named route, so if we change the route's regular expression to something like `"/sayhello/:name"`, all the links will reflect the change.

#### Add hierarchy

URL's are hierarchal by nature, so are your routes.

Suposse you have an admin page that allows you to list and edit users, you probably have the following URL's

* `/admin`: Dashboard of the admin
* `/admin/user`: A list of users with the possible actions
* `/admin/user/:id/edit`: Edit user form

We can define that structure using the routes:

```js
routes.get({
    name: "admin",
    re: '/admin',
    handler: function(req, res){
        res.send('Admin dashboard');
    }
});

routes.get({
    name: "admin_user_list",
    re: '/user',
    parent: routes.getRoute('admin'),
    handler: function(req, res){
        res.send('List of users');
    }
});

routes.get({
    name: "admin_user_edit",
    re: '/:id/edit',
    parent: routes.getRoute('admin_user_list'),
    handler: function(req, res){
        res.send('Edit form');
    }
});
```

The parent property is the parent Route (a Javascript Object Literal),  and indicates that our `re` depends on our ancestors.

 In here we also show another way to define the route handler. Instead of adding it after the Javascript Object (the Route), we add it as a property.


### Take it for a spin
You got this far and you are still interested? Check out how to install and bootstrap the library with this [Basic Example](https://github.com/hrajchert/express-shared-routes-examples/blob/master/docs/1-basic.md).

Once you learn the basics, check out how to [create a menu bar](https://github.com/hrajchert/express-shared-routes-examples/blob/master/docs/2-menu.md) and share your routes with the client. Are you using RequireJS? [Here is the same example](https://github.com/hrajchert/express-shared-routes-examples/blob/master/docs/3-menu-requirejs.md) using AMD loader.

See how to create complex navigation like this [Breadcrum example](https://github.com/hrajchert/express-shared-routes-examples/blob/master/docs/4-breadcrum.md).

### TODO
* Add a string as parent property
* Add an example of modular MVC express apps
* Ability to override a rule
* Maybe add a prototype to the routes so it take less code to do navigation tools


