var open = require('open');

module.exports = function(grunt) {

  function mapLibs(libs) {
    var result = {};
    libs.forEach(function(lib) {
      var targetFilename = lib.split('/').pop();
      if (lib.indexOf('/') === -1) {
        targetFilename += '.js';
        lib = lib + '/index.js';
      }
      ['test', 'dev'].forEach(function(target) {
        result['pub/dist/' + target + '/lib/' + targetFilename] = 'lib/' + lib;
      });
    });
    return result;
  }

  var copy = mapLibs([
    'requirejs/require.js',
    'angular/angular.js',
    'angular-resource',
    'jquery/jquery.js',
    'lodash/lodash.js',
    'moment/moment.js',

    'mocha/mocha.js',
    'chai/chai.js',
    'chai-jquery/chai-jquery.js',
    'sinon',
    'sinon-chai/lib/sinon-chai.js',
    'angular-mock'
  ]);
  copy['pub/dist/test/lib/mocha.css'] = 'lib/mocha/mocha.css';

  grunt.initConfig({
    copy: {
      all: {
        files: copy
      }
    },

    jade: {
      options: {
        pretty: true
      },
      src: {
        files: {
          'pub/dist/dev/index.html': 'pub/index.jade',
          'pub/dist/test/runner.html': 'pub/runner.jade'
        }
      }
    },

    coffee: {
      options: {
        bare: true
      },
      src: {
        files: {
          'pub/dist/dev/src/*.js': 'pub/src/**/*.coffee'
        }
      },
      spec: {
        files: {
          'pub/dist/test/src/*.js': 'pub/src/**/*.coffee',
          'pub/dist/test/spec/*.js': 'pub/spec/**/*.coffee'
        }
      }
    },

    watch: {
      dev: {
        files: ['pub/src/**/*.coffee', 'pub/index.jade'],
        tasks: ['build:dev', 'reload']
      },
      test: {
        files: ['pub/src/**/*.coffee', 'pub/spec/**/*.coffee'],
        tasks: ['build:test', 'mocha']
      }
    },

    reload: {
      port: 8082,
      proxy: {
        host: 'localhost',
        port: 8080
      }
    },

    server: {
      port: 8080,
      base: 'pub/dist/dev'
    },

    open: {
      url: 'http://localhost:8082/'
    },

    mocha: {
      all: {
        src: 'pub/dist/test/runner.html',
        run: false
      }
    }

  });

  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-reload');
  grunt.loadNpmTasks('grunt-mocha');
  grunt.loadNpmTasks('grunt-contrib-jade');

  grunt.registerMultiTask('open', 'Open a URL', function() {
    open(this.data);
  });

  grunt.registerTask('build:dev', 'copy jade coffee:src');
  grunt.registerTask('build:test', 'copy jade coffee:spec');
  grunt.registerTask('tdd', 'watch:test');
  grunt.registerTask('default', 'build:dev server reload open watch:dev');

}