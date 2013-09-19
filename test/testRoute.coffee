should = require('should')
Route = require('../index').Route

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


describe 'Route', () ->
    r = new Route
    describe "should exist with null", () ->
        it 'should ', () ->
            obj = null


    describe '#getRe()', () ->
        it 'should use parents re to build its own', () ->
            r.getRe(admin_news_list).should.equal '/admin/news/'

    describe '#is()', () ->
        it 'should work when the object is the selected', () ->
            r.is(admin_news_list, 'admin_news_list').should.be.ok

        it 'should fail when the object is parent of the selected', () ->
            r.is(admin_news, 'admin_news_list').should.be.false

    describe '#isSonOf', () ->
        it 'should work when the object is the selected', () ->
            r.isSonOf(admin_news,'admin_news').should.be.ok

        it 'should work when the object is a child of the selected', () ->
            r.isSonOf(admin_news_list,'admin_news').should.be.ok

        it 'should fail when the object is a parent of the selected', () ->
            r.isSonOf(admin,'admin_news').should.be.false

    describe '#getLink()', () ->
        it 'should replace a named selector when no validation', () ->
            r.getLink(admin_news_edit,{_id:9}).should.equal('/admin/news/9/edit')

        it 'should fail if there is some parameter undefined', () ->
            should.not.exist r.getLink(admin_news_edit,{})

        it 'it should pass when validation parameters are correct', () ->
            route = '/admin/edit/:id(\\d{1,3})_lala.html'
            r.getLink({re:route},{id:999}).should.equal('/admin/edit/999_lala.html')

        it 'it should return null when it doesnt pass the parameter validation', () ->
            route = '/admin/edit/:id(\\d{1,3})_lala.html'
            should.not.exist r.getLink({re:route},{id:9999})

        it 'should replace multiple parameters', () ->
            route = '/admin/:obj1(\\d{1,3})/relation/:obj2(\\w+)'
            r.getLink({re:route},{obj1:999,obj2:'pepe'}).should.equal('/admin/999/relation/pepe')

        # Optional parameters, kind of edgy /admin/edit/:id? /admin/edit/1234 o /admin/edit, mmhmh
        # it.skip 'should replace a position regexp?'










