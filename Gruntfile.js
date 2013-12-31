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

        umd: {
            browserManager: {
                src: 'lib/routeBrowserManager.js',
                objectToExport: 'RouteBrowserManager', // internal object that will be exported
                globalAlias: 'RouteManager', // changes the name of the global variable
                amdModuleId: 'RouteManager',
                deps: {
                    'default': ['Route']
                }
            },
            route: {
                src: 'lib/route.js',
                objectToExport: 'Route', // internal object that will be exported
                globalAlias: 'Route', // changes the name of the global variable
                amdModuleId: 'Route',
            }
        },
        uglify: {
            my_target: {
                options: {
                    report: 'gzip'
                },
                files: {
                    'routeManager.min.js': ['lib/route.js', 'lib/routeBrowserManager.js']
                }
            }
        }
    });

    // Load the plugins
    grunt.loadNpmTasks('grunt-contrib-coffee');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-umd');
    grunt.loadNpmTasks('grunt-cafe-mocha');


    // Default task(s).
    grunt.registerTask('default', ['coffee','umd', 'uglify']);
    grunt.registerTask('test', ['coffee','umd','cafemocha']);

};