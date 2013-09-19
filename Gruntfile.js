module.exports = function(grunt) {

    // Project configuration.
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        // Compiles coffeescript for the client side
        coffee: {
            compile: {
                options:{
                    bare: true
                },
                files: {
                  'index.js': 'src/index.coffee',
                  'lib/route.js': 'src/route.coffee',
                  'lib/routeBrowserManager.js': 'src/routeBrowserManager.coffee',
                  'lib/routeManager.js': 'src/routeManager.coffee'
                }
            }
        },
        // Executes unitTest
        cafemocha: {
            express_shared_routes: {
                src: 'test/*.coffee',
                options: {
                    ui: 'bdd',
                    require: [
                        'should'
                    ]
                }
            }
        },


    });

    // Load the plugins
    grunt.loadNpmTasks('grunt-contrib-coffee');
    grunt.loadNpmTasks('grunt-cafe-mocha');


    // Default task(s).
    grunt.registerTask('default', ['coffee']);

};