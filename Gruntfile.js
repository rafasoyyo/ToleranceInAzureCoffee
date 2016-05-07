module.exports = function(grunt) {
    require('jit-grunt')(grunt);

    grunt.initConfig({
        less: {
            development: {
                options: {
                    compress: true,
                    yuicompress: true,
                    optimization: 2
                },
                files: {
                    "./public/stylesheets/style.css": "./less/style.less" // destination file and source file
                }
            }
        },
        coffee: {
            development: {
                options: {
                    // separator: ';',
                    // join: true,
                    // sourceMap: true,
                    bare: true
                },
                files: {
                    './public/javascripts/ng_scripts.js': ['./coffee/angular/*.coffee', './coffee/angular/**/*.coffee'], // compile and concat into single file 
                    './public/javascripts/scripts.js': ['./coffee/scripts/*.coffee'] // compile and concat into single file 
                }
            }
        },
        uglify: {
            // development: {
                options: {
                    sourceMap: true
                    //sourceMapIn: './public/javascripts/*.js.map'
                },
                files: {
                    './public/javascripts/ng_scripts.min.js': ['./public/javascripts/ng_scripts.js'],
                    './public/javascripts/scripts.min.js': ['./public/javascripts/scripts.js']
                }
            // }
        },
        jade: {
            compile: {
                options: {
                    // client: false,
                    pretty: true
                },
                files: [{
                    expand: true,
                    // flatten: true,
                    cwd : 'views/html',
                    src : ['*.jade'],
                    dest: 'public/templates',
                    ext : '.html'
                }]
            }
        },
        livereload: {
            options: {
                base: 'public',
            },
            files: ['public/**/*']
        },
        watch: {
            styles: {
                files: ['less/**/*.less'], // which files to watch
                tasks: ['less'],
                options: {
                    nospawn: true
                }
            },
            scripts:{
                files: ['coffee/*.coffee', 'coffee/**/*.coffee'], // which files to watch
                tasks: ['coffee']                
            },
            ugli:{
                files: ['public/javascripts/*.js' /*, '!public/javascripts/*.min.js'*/], // which files to watch
                tasks: ['uglify']  
            },
            templates:{
                files: ['views/**/*.jade'], // which files to watch
                tasks: ['jade']                
            }
        }
    });

grunt.registerTask('default', ['less', 'coffee', 'uglify', 'jade', 'livereload', 'watch']);
};