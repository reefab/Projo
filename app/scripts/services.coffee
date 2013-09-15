angular.module('powerServices', ['ngResource'])
    .factory('Power', ($resource) ->
        $resource '/power/:status',
            {},
            query:
                method: 'GET'
            on:
                method: 'PUT'
                params:
                    status: 'on'
            off:
                method: 'PUT'
                params:
                    status: 'off'
)

angular.module('blankServices', ['ngResource'])
    .factory('Blank', ($resource) ->
        $resource '/blank/:status',
            {},
            query:
                method: 'GET'
            on:
                method: 'PUT'
                params:
                    status: 'on'
            off:
                method: 'PUT'
                params:
                    status: 'off'
)

angular.module('modelnameServices', ['ngResource'])
    .factory('Modelname', ($resource) ->
        $resource '/modelname',
            {},
            query:
                method: 'GET'
)


angular.module('menuServices', ['ngResource'])
    .factory('Menu', ($resource) ->
        $resource '/menu/:status',
            {},
            on:
                method: 'PUT'
                params:
                    status: 'on'
            off:
                method: 'PUT'
                params:
                    status: 'off'
            left:
                method: 'PUT'
                params:
                    status: 'left'
            right:
                method: 'PUT'
                params:
                    status: 'right'
            up:
                method: 'PUT'
                params:
                    status: 'up'
            down:
                method: 'PUT'
                params:
                    status: 'down'
            enter:
                method: 'PUT'
                params:
                    status: 'enter'
)
