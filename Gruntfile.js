module.exports = function(grunt) {
  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    coffee: {
      compile: {
        files: {
          'src/ruc_jquery_validator.js': 'src/ruc_jquery_validator.coffee',
          'spec/ruc_jquery_validatorSpec.js': 'spec/ruc_jquery_validatorSpec.coffee'
        }
      }
    },
    coffeelint: {
      lint: ['src/*.coffee', 'spec/*.coffee'],
      options: {
        'camel_case_classes': {
          level: 'ignore'
        }
      }
    },
    jasmine: {
      test: {
        src: 'src/*.js'
      },
      dist: {
        src: 'dist/*.js'
      },
      options: {
        specs: 'spec/*Spec.js',
        helpers: ['lib/jasmine-jquery-1.5.0/jasmine-jquery.js'],
        vendor: ['lib/jquery-1.9.1/jquery-1.9.1.js']
      }
    },
    watch: {
      coffee: {
        files: ['src/**/*.coffee', 'spec/*Spec.coffee'],
        tasks: ['coffeelint:lint', 'coffee:compile']
      },
      jasmine: {
        files: ['src/**/*.js', 'spec/*Spec.js'],
        tasks: 'jasmine:test'
      }
    },
    uglify: {
      options: {
        banner:
          '/**\n' +
          ' * <%= pkg.name %>\n' +
          ' * @author <%= pkg.author %>\n' +
          ' * @license <%= pkg.license %> <%= pkg.licenseURL %>\n' +
          ' * @version <%= pkg.version %> (<%= grunt.template.today("yyyy-mm-dd") %>)\n' +
          ' * @homepage <%= pkg.homepage %>\n' +
          ' */\n'
      },
      dist: {
        files: {
          'dist/ruc_jquery_validator.min.js': 'src/ruc_jquery_validator.js'
        }
      }
    }
  });

  // Load the plugins that provide tasks.
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-coffeelint');
  grunt.loadNpmTasks('grunt-contrib-jasmine');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-uglify');

  // Default task(s).
  grunt.registerTask('default', ['coffeelint:lint', 'coffee:compile', 'jasmine:test']);
  // Build task
  grunt.registerTask('build', ['coffee:compile', 'uglify:dist', 'jasmine:dist']);
};
