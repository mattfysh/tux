do ->

  # list test libraries
  testLibPaths = [
    'chai',
    'chai-jquery',
    'sinon',
    'sinon-chai',
    'angular-mocks'
  ]

  # expose the bdd mocha syntax
  mocha.setup 'bdd'

  # prevent app from being bootstrapped during test run
  angular.bootstrap = ->

  # add specs to loading configuration
  for src in require.srcPaths
    specPath = "../spec/#{src}.spec"
    require.deps.push specPath
    # all specs require angular-mocks to be loaded
    require.shim[specPath] = ['angular-mocks']

  # ensure jquery is loaded before loading chai-jquery
  require.shim['chai-jquery'] = ['jquery']

  # create paths to the test libraries and add them to the existing paths
  require.paths = require.makeLibPaths testLibPaths, require.paths

  # prepend the test libraries to the existing dependencies
  require.deps = testLibPaths.concat require.deps

  # define the callback that sets up and executes the test run after all modules have loaded
  require.callback = (chai, chaiJquery, sinon, sinonChai) ->
    chai.use chaiJquery
    chai.use sinonChai
    chai.should()
    mocha.run()
