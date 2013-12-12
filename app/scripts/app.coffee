'use strict'

angular.module('configuration', [])
    .constant('URI_ROOT', '/luci/projo')

angular.module('ProjoApp', ['hmTouchEvents', 'powerServices', 'menuServices', 'blankServices', 'modelnameServices', 'stereoServices', 'configuration'])
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .otherwise
        redirectTo: '/'

