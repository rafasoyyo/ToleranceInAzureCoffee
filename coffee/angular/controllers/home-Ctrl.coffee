
###
# Home controller
# @namespace Angular.Controller
# @module home-Ctrl
###

tolerantApp.controller('home-Ctrl', ['$scope', '$items', '$shared', ($scope, $items, $shared)->
    ###
    # Description
    # @memberOf home-Ctrl
    # @method $scope.get_all
    # @param algo
    # @param algo2
    # @return algo2
    # @returnprop algo2
    ###
    $scope.get_all = (param)->
        if param
            $items.get_all().save(param).$promise.then(
                                    (res)-> 
                                            # console.log res
                                            $scope.all = res.all
                                            $scope.productos  = res.productos
                                            $scope.lugares    = res.lugares
                                            $scope.afecciones = res.afecciones
                                ,
                                    (err)-> console.error err
                                )

        if not param
            $items.get_all().get().$promise.then(
                                    (res)-> 
                                            # console.log res
                                            $scope.all = res.all
                                            $scope.productos  = res.productos
                                            $scope.lugares    = res.lugares
                                            $scope.afecciones = res.afecciones
                                ,
                                    (err)-> console.error err
                                )
    $scope.get_all()

    $scope.$shared = $shared
    $scope.$watchCollection('$shared', (end, ini)->
        # console.log end, ini 
        if end isnt ini then $scope.get_all(end)
    )

])