require = do ->

  libPaths = [
    'angular-resource',
    'moment',
    'jquery',
    'lodash'
  ]
  
  srcPaths = [
    'schedule/model',
    'schedule/group'
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

angular.module('tux.services', ['ngResource']);