angular.module('powerServices', ['ngResource', 'configuration'])
    .factory('Power', ['$resource', 'URI_ROOT', ($resource, URI_ROOT) ->
        $resource "#{URI_ROOT}/power/:status",
            {},
            query:
                method: 'GET'
            on:
                method: 'POST'
                params:
                    status: 'on'
            off:
                method: 'POST'
                params:
                    status: 'off'
])

angular.module('blankServices', ['ngResource', 'configuration'])
    .factory('Blank', ['$resource', 'URI_ROOT', ($resource, URI_ROOT) ->
        $resource "#{URI_ROOT}/blank/:status",
            {},
            query:
                method: 'GET'
            on:
                method: 'POST'
                params:
                    status: 'on'
            off:
                method: 'POST'
                params:
                    status: 'off'
])

angular.module('modelnameServices', ['ngResource', 'configuration'])
    .factory('Modelname', ['$resource', 'URI_ROOT', ($resource, URI_ROOT) ->
        $resource "#{URI_ROOT}/modelname",
            {},
            query:
                method: 'GET'
])


angular.module('menuServices', ['ngResource', 'configuration'])
    .factory('Menu', ['$resource', 'URI_ROOT', ($resource, URI_ROOT) ->
        $resource "#{URI_ROOT}/menu/:status",
            {status: '@status'},
            send:
                method: 'POST'
])

angular.module('stereoServices', ['ngResource', 'configuration'])
    .factory('Stereo', ['$resource', 'URI_ROOT', ($resource, URI_ROOT) ->
        $resource "#{URI_ROOT}/3d/:status",
            {status: '@status'},
            query:
                method: 'GET'
            change:
                method: 'POST'
])
