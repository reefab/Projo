'use strict'

angular.module('ProjoApp')
  .controller 'MainCtrl', ($scope, Power) ->
    $scope.power = Power.query()
