should = require('should')
RouteManager = require('../index').RouteManager

dummyMethod = () ->
    # noop

dummyMethod2 = () ->
    # noop

class FakeApp
    getroutes: []
    get: (route, methods...) ->
        @getroutes.push route

    putroutes: []
    put: (route, methods...) ->
        @putroutes.push route

    all: (route, methods...) ->
        @getroutes.push route
        @putroutes.push route

# Initialize an example hierarchy
admin =
    re : "/admin"
    name: "admin"

admin_news =
    parent: admin
    re : "/news"
    name: "admin_news"

admin_news_list =
    parent: admin_news
    re: "/"
    name: "admin_news_list"

admin_news_edit =
    parent: admin_news
    re: "/:_id/edit"
    name: "admin_news_edit"


describe 'RouteManager', () ->
    # Its kind of weird to test the route manages because it has two types of methods. The construction ones, that
    # will construct the route hierarchy, and the usage ones, that will allow me to create links and whatnot. And the
    # weird part is that for testing the usage, I need the map to be created, and for testing the creation, I need the
    # usage to work.
    describe 'construction', () ->
        routes = new RouteManager
        route_with_cb_middleware =
            re: "/someRoute_with_cb"
            name: "route_with_cb_middleware"
            cb: dummyMethod

        # The difference between the following route and the above, is that the following uses a "new"
        # concept where you can define the pre-requisites of the function separate from the actual route
        # handler.
        route_with_pre_middleware =
            re: "/someRoute_with_pre_and_handler"
            name: "route_with_cb_middleware"
            pre: dummyMethod
            handler: dummyMethod2

        # Same as route_with_pre_middleware but without prerequisites
        route_with_handler_nopre_middleware =
            re: "/someRoute_with_handler_nopre"
            name: "route_with_cb_middleware"
            handler: dummyMethod

        beforeEach () ->
            routes.clear()


        describe '#get()', () ->
            it 'should not throw when inserting with a middleware', () ->
                (() ->
                    routes.get admin_news, dummyMethod
                ).should.not.throw();

            it 'should throw when inserting without a middleware', () ->
                (() ->
                    routes.get admin_news
                ).should.throw();

            it 'should not throw when inserting without a middleware, but the middleware is defined in the route using cb', () ->
                (() ->
                    routes.get route_with_cb_middleware
                ).should.not.throw();

            it 'should not throw when inserting without a middleware, but the middleware is defined in the route using pre and handler', () ->
                (() ->
                    routes.get route_with_pre_middleware
                ).should.not.throw();

            it 'should concatenate the pre and the handler', () ->
                routes.get route_with_pre_middleware
                # This knows about the implementation, :S
                route = routes.routeList[0]
                route.cb.should.have.lengthOf(2)

            it 'should work with the handler and no pre', () ->
                routes.get route_with_handler_nopre_middleware
                # This knows about the implementation, :S
                route = routes.routeList[0]
                route.cb.should.have.lengthOf(1)

            it 'should override the default middleware using cb', () ->
                routes.get route_with_cb_middleware, dummyMethod, dummyMethod2
                # This knows about the implementation, :S
                route = routes.routeList[0]
                route.cb.should.have.lengthOf(2)

            it 'should override the default middleware using pre', () ->
                routes.get route_with_pre_middleware, dummyMethod
                # This knows about the implementation, :S
                route = routes.routeList[0]
                route.cb.should.have.lengthOf(1)


    describe 'usage', () ->
        routes = new RouteManager
        beforeEach () ->
            routes.clear()
            routes.get admin, dummyMethod
            routes.get admin_news, dummyMethod
            routes.get admin_news_list, dummyMethod
            # This would be a form show
            routes.get admin_news_edit, dummyMethod
            # This would be the form update
            routes.put admin_news_edit, dummyMethod


        describe '#getRoute()', () ->
            it 'should return null for inexistent route', () ->
                routes.getRoute('admin_news_list').should.not.exist


            it 'should return an object when the route exists', () ->
                route = routes.getRoute('admin_news_list')
                route.should.exist
                route.should.be.a('object').and.have.property('name', 'admin_news_list')

            it 'should not be the same object (aka clone)', () ->
                route = routes.getRoute('admin_news_list')
                route.should.be.a('object').and.have.property('name', admin_news_list['name'])
                route.should.be.a('object').and.have.property('re', admin_news_list['re'])
                route.should.not.equal admin_news_list


        describe '#applyRoutes()', () ->
            it 'should apply the routes in the correct order and the correct type', () ->
                app = new FakeApp
                routes.applyRoutes app
                # console.log routes.routeMap
                app.getroutes.should.have.lengthOf(4)
                app.getroutes[0].should.equal('/admin')
                app.getroutes[1].should.equal('/admin/news')
                app.getroutes[2].should.equal('/admin/news/')
                app.getroutes[3].should.equal('/admin/news/:_id/edit')

                app.putroutes.should.have.lengthOf(1)
                app.putroutes[0].should.equal('/admin/news/:_id/edit')