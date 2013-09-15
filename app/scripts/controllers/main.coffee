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
        if $scope.power?.status? and $scope.power.status
            Power.off()
            console.log "Power off"
        else
            Power.on()
            console.log "Power on"
            # big 20sec delay needed before the projector reacts when turning on
            $timeout($scope.update_power, 20000)

    $scope.blank_switch = ->
        console.log "Blank button pressed"
        if $scope.blank?.status? and $scope.blank.status
            Blank.off()
            console.log "Blank off"
        else
            Blank.on()
            console.log "Blank on"
        $timeout($scope.update_blank, 2000)

    $scope.menu = (key) ->
        console.log "Menu command #{key}"
        Menu.send status:key
