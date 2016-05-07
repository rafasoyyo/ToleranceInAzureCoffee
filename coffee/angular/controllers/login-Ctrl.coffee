
tolerantApp.controller('loginModal-Ctrl', ['$scope', '$uibModalInstance', '$account', ($scope, $uibModalInstance, $account)->
    
    # console.log $scope
    
    
    
    $scope.login_submit = ->
        $scope.error_login = false
        console.log $scope.login

        if $scope.login_form.$valid
            $account.login($scope.login).then(
                        (res)-> console.log res; location.reload()
                    ,
                        (err)-> 
                                console.error err
                                if err.status is 401 
                                    $scope.error_login = 'Usuario o contraseña incorrectos'
                                else
                                    $scope.error_login = 'Error de acceso'

                    )


    $scope.register_submit = ->
        $scope.error_register = false

        if $scope.register_form.$valid 
            # console.log $scope.register
            $account.register($scope.register).then(
                        (res)-> console.log res; location.reload()
                    ,
                        (err)-> 
                            console.error err
                            if err.data.id 
                                switch err.data.id 
                                    when 1 then return $scope.error_register = 'El nombre de usuario es necesario'
                                    when 2 then return $scope.error_register = 'Nombre de usuario en uso'
                                    when 3 then return $scope.error_register = 'Email en uso'
                                    else $scope.error_register = 'Error de acceso'
                            else
                                $scope.error_register = 'Error de acceso'
                    )


    $scope.$watchCollection 'register', (fin, ini)->
        
        $scope.error_register = false
        $scope.checkin = 
                        status: false
                        value : false
        
        if typeof fin isnt 'undefined'
            console.log $scope
            if fin.password and fin.repeat
                $scope.register_form.register_repeat.$setValidity("unmatch", fin.password is fin.repeat )
            else 
                $scope.register_form.register_repeat.$setValidity("unmatch", true )

            if (not fin.nickname) or (typeof ini isnt 'undefined' and fin.nickname is ini.nickname) then return false
            
            $scope.checkin =
                            status: true
                            value : false

            $account.available({username: fin.nickname})
                    .then(
                        (res)-> 
                                console.log res
                                $scope.checkin.value = """<i class="fa fa-check txt-green"></i>
                                                        <span class="txt-green txt-sbold small">Este nombre de usuario está disponible</span>"""
                    ,
                        (err)-> 
                                console.error err
                                $scope.checkin.value = """<i class="fa fa-times txt-red"></i>
                                                        <span class="txt-red txt-sbold small">Este nombre de usuario ya está en uso</span>"""
                    )

    $scope.password_recover = ->

        if not $scope.login or not $scope.login.username 
            $scope.recover_ok = null
            return $scope.error_login = 'Escribe tu nombre de usuario o tu email'
   
        $account.recover({username:$scope.login.username}).then(
                    (res)-> 
                            console.log res
                            $scope.recover_ok  = 'Se ha enviado un email con las instrucciones al correo asociado a esta cuenta.'
                            $scope.error_login = null
                ,
                    (err)-> 
                        console.error err
                        if err.data.id 
                            switch err.data.id 
                                when 1 then return $scope.error_login = 'No hay cuentas registradas con estos datos.'
                                else $scope.error_login = 'Error de acceso'
                        else
                            $scope.error_register = 'Error de acceso'
                )
])