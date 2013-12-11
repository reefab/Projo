'use strict'

angular.module('configuration', [])
    .constant('URI_ROOT', 'http://localhost:8080\:8080/luci/projo')

angular.module('ProjoApp', ['hmTouchEvents', 'powerServices', 'menuServices', 'blankServices', 'modelnameServices', 'stereoServices', 'configuration'])
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .otherwise
        redirectTo: '/'

