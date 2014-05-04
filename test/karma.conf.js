// Karma configuration
// Generated on Sun May 04 2014 18:31:59 GMT+0200 (CEST)

module.exports = function(config) {
	config.set({

		// base path that will be used to resolve all patterns (eg. files, exclude)
		basePath: "../",


		// frameworks to use
		// available frameworks: https://npmjs.org/browse/keyword/karma-adapter
		frameworks: ["mocha"],


		// list of files / patterns to load in the browser

		files: [
			"node_modules/sinon/pkg/sinon-1.9.1.js",
			"node_modules/should/should.js",
			"dist/js/vendor.js",
			"bower_components/angular-mocks/angular-mocks.js",
			"app/**/*.js",
			"test/unit/**/*.js"
		],


		// list of files to exclude
		exclude: [
			"app/main.js"
		],


		// preprocess matching files before serving them to the browser
		// available preprocessors: https://npmjs.org/browse/keyword/karma-preprocessor
		preprocessors: {
			"app/components/**/**.js": "coverage",
			"app/pages/**/**.js": "coverage"
		},

		// test results reporter to use
		// possible values: "dots", "progress"
		// available reporters: https://npmjs.org/browse/keyword/karma-reporter
		reporters: [
			"dots",
			"coverage"
		],

		// options for the istanbul coverage reporter
		coverageReporter: {
			type: "html",
			dir: "test/coverage/"
		},


		// web server port
		port: 9876,


		// enable / disable colors in the output (reporters and logs)
		colors: true,


		// level of logging
		// possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
		logLevel: config.LOG_INFO,


		// enable / disable watching file and executing tests whenever any file changes
		autoWatch: true,


		// start these browsers
		// available browser launchers: https://npmjs.org/browse/keyword/karma-launcher
		browsers: [
			"Chrome",
			//"Firefox",
			//"Safari"
		],


		// Continuous Integration mode
		// if true, Karma captures browsers, runs the tests and exits
		singleRun: false
	});
};