angular.module('powerServices', ['ngResource'])
    .factory('Power', ($resource) ->
        $resource '/power', 
            {}, 
            query: 
                method: 'GET'
            on:
                method: 'PUT'
                url: '/power/on'
            off:
                method: 'PUT'
                url: '/power/off'
)

        
