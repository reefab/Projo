'use strict'

angular.module('ProjoApp', ['hmTouchEvents', 'powerServices', 'menuServices', 'blankServices', 'modelnameServices', 'stereoServices'])
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .otherwise
        redirectTo: '/'
