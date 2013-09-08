'use strict'

angular.module('ProjoApp')
  .controller 'MainCtrl', ($scope, Power, Blank, Menu, Modelname) ->
    $scope.blank = Blank.query()
    $scope.modelname = Modelname.query()
    $scope.power = Power.query()

    # $scope.init = () ->

    $scope.power_switch = () ->
        console.log "Power button pressed"
        if $scope.disable
            Power.on()
            $scope.power = {status: "on"}
            # $scope.disable = false
        else
            Power.off()
            $scope.power = {status: "off"}
            # $scope.disable = true

    $scope.blank_switch = () ->
        console.log "Blank button pressed"
        current = Blank.query()
        if current.status == "on"
            Blank.off()
        else
            Blank.on()

    $scope.enter = () ->
        console.log "Enter"
        Menu.enter()

    $scope.menuup = () ->
        console.log "Menu up!"
        Menu.up()

    $scope.menudown = () ->
        console.log "Menu down!"
        Menu.down()

    $scope.menuleft = () ->
        console.log "Menu left!"
        Menu.left()

    $scope.menuright = () ->
        console.log "Menu right!"
        Menu.right()

    $scope.menu = () ->
        console.log "Menu activated"
        Menu.on()

    $scope.back = () ->
        console.log "Menu desactivated"
        Menu.off()
