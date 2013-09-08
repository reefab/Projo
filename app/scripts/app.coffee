'use strict'

angular.module('ProjoApp', ['hmTouchEvents', 'powerServices', 'menuServices', 'blankServices', 'modelnameServices'])
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .otherwise
        redirectTo: '/'
