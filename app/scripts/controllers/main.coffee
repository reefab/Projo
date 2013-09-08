'use strict'

angular.module('ProjoApp')
  .controller 'MainCtrl', ($scope, $timeout, Power, Blank, Menu, Modelname) ->
    $scope.blank = Blank.query()
    $scope.modelname = Modelname.query()
    $scope.power = Power.query()

    $scope.update_power = ->
        $scope.power = Power.query()
        $scope.modelname = Modelname.query()
        $scope.blank = Blank.query()

    $scope.update_blank = ->
        $scope.blank = Blank.query()

    $scope.power_switch = ->
        console.log "Power button pressed"
        if $scope.power?.status? and $scope.power.status == 'on'
            Power.off()
            console.log "Power off"
        else
            Power.on()
            console.log "Power on"
        $timeout($scope.update_power, 10000)

    $scope.blank_switch = ->
        console.log "Blank button pressed"
        if $scope.blank?.status? and $scope.blank.status == 'on'
            Blank.off()
            console.log "Blank off"
        else
            Blank.on()
            console.log "Blank on"
        $timeout($scope.update_blank, 10000)

    $scope.enter = ->
        console.log "Enter"
        Menu.enter()

    $scope.menuup = ->
        console.log "Menu up!"
        Menu.up()

    $scope.menudown = ->
        console.log "Menu down!"
        Menu.down()

    $scope.menuleft = ->
        console.log "Menu left!"
        Menu.left()

    $scope.menuright = ->
        console.log "Menu right!"
        Menu.right()

    $scope.menu = ->
        console.log "Menu activated"
        Menu.on()

    $scope.back = ->
        console.log "Menu desactivated"
        Menu.off()
