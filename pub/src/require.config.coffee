require = do ->

  libPaths = [
    'angular-resource',
    'moment',
    'jquery'
  ]
  
  srcPaths = [
    'schedule/model'
  ]

  makeLibPaths = (libs, paths = {}) ->
    paths[lib] = "../lib/#{lib}" for lib in libs
    paths

  baseUrl: 'src'
  shim:
    'bootstrap': libPaths.concat srcPaths
  deps: ['bootstrap']
  paths: makeLibPaths libPaths
  makeLibPaths: makeLibPaths
  srcPaths: srcPaths