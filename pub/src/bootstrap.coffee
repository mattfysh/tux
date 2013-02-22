angular.module('tux', ['tux.services'])
.controller 'a1', (allSchedules) ->
  console.log allSchedules

angular.bootstrap document, ['tux']
