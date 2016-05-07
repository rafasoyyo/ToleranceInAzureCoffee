
/*
 * App definition
 * @namespace Angular
 * @module Angular
 */

/*
 * @memberOf Angular
 * @method app.definition
 * @param {Array} Injections ['ngResource', 'ngSanitize', 'ngAnimate', 'ui.bootstrap']
 */
var tolerantApp;

tolerantApp = angular.module('tolerantApp', ['ngResource', 'ngSanitize', 'ngAnimate', 'ui.bootstrap']);

tolerantApp.controller('body-Ctrl', ['$scope', function($scope) {}]);


/*
 * Header controller
 * @namespace Angular.Controller
 * @module header-Ctrl
 * @see rafa
 */
tolerantApp.controller('header-Ctrl', [
  '$scope', '$uibModal', '$shared', function($scope, $uibModal, $shared) {

    /*
    	 * Open login and register modal
    	 * @memberOf header-Ctrl
    	 * @method $scope.loginModal
    	 * @param none
    	 * @return none
     */
    $scope.loginModal = function() {
      var modalInstance;
      return modalInstance = $uibModal.open({
        animation: true,
        templateUrl: '/templates/loginModal.html',
        controller: 'loginModal-Ctrl',
        windowClass: 'login-modal',
        size: 'md'
      });
    };
    return $scope.$shared = $shared;
  }
]);


/*
 * Home controller
 * @namespace Angular.Controller
 * @module home-Ctrl
 */
tolerantApp.controller('home-Ctrl', [
  '$scope', '$items', '$shared', function($scope, $items, $shared) {

    /*
     * Description
     * @memberOf home-Ctrl
     * @method $scope.get_all
     * @param algo
     * @param algo2
     * @return algo2
     * @returnprop algo2
     */
    $scope.get_all = function(param) {
      if (param) {
        $items.get_all().save(param).$promise.then(function(res) {
          $scope.all = res.all;
          $scope.productos = res.productos;
          $scope.lugares = res.lugares;
          return $scope.afecciones = res.afecciones;
        }, function(err) {
          return console.error(err);
        });
      }
      if (!param) {
        return $items.get_all().get().$promise.then(function(res) {
          $scope.all = res.all;
          $scope.productos = res.productos;
          $scope.lugares = res.lugares;
          return $scope.afecciones = res.afecciones;
        }, function(err) {
          return console.error(err);
        });
      }
    };
    $scope.get_all();
    $scope.$shared = $shared;
    return $scope.$watchCollection('$shared', function(end, ini) {
      if (end !== ini) {
        return $scope.get_all(end);
      }
    });
  }
]);

tolerantApp.controller('item-Ctrl', [
  '$scope', '$filter', '$timeout', '$user', '$items', function($scope, $filter, $timeout, $user, $items) {
    var $fav, iteartor;
    iteartor = 5;
    $scope.limited = iteartor;
    $scope.see_comment = function() {
      return $scope.limited = $scope.limited + iteartor;
    };
    $scope.get_comment = function() {
      if ($scope.clase === 'producto') {
        return $items.product_comment_get($scope.ident).then(function(res) {
          return $scope.comments = $filter('orderBy')(res.comentarios, 'created', true);
        }, function(error) {
          return console.error(error);
        });
      }
    };
    $scope.post_comment = function() {
      if ($scope.clase === 'producto') {
        return $items.product_comment_post($scope.comment).then(function(res) {
          console.log(res);
          $scope.product_comment.$setPristine();
          $scope.comment = null;
          return $scope.get_comment();
        }, function(err) {
          return console.error(err);
        });
      }
    };
    $timeout($scope.get_comment, 1);
    $fav = angular.element('#fav').find('i');
    return $scope.save_fav = function(id, data) {
      console.log(id, data, $scope.clase);
      return $user.save_fav().save({
        id: id
      }, {
        item: data,
        clase: $scope.clase
      }).$promise.then(function(res) {
        console.log(res);
        if (res.option === "removed") {
          return $fav.removeClass('fa-star').addClass('fa-star-o');
        }
        if (res.option === "added") {
          return $fav.removeClass('fa-star-o').addClass('fa-star');
        }
      }, function(err) {
        return console.error(err);
      });
    };
  }
]);

tolerantApp.controller('loginModal-Ctrl', [
  '$scope', '$uibModalInstance', '$account', function($scope, $uibModalInstance, $account) {
    $scope.login_submit = function() {
      $scope.error_login = false;
      console.log($scope.login);
      if ($scope.login_form.$valid) {
        return $account.login($scope.login).then(function(res) {
          console.log(res);
          return location.reload();
        }, function(err) {
          console.error(err);
          if (err.status === 401) {
            return $scope.error_login = 'Usuario o contraseña incorrectos';
          } else {
            return $scope.error_login = 'Error de acceso';
          }
        });
      }
    };
    $scope.register_submit = function() {
      $scope.error_register = false;
      if ($scope.register_form.$valid) {
        return $account.register($scope.register).then(function(res) {
          console.log(res);
          return location.reload();
        }, function(err) {
          console.error(err);
          if (err.data.id) {
            switch (err.data.id) {
              case 1:
                return $scope.error_register = 'El nombre de usuario es necesario';
              case 2:
                return $scope.error_register = 'Nombre de usuario en uso';
              case 3:
                return $scope.error_register = 'Email en uso';
              default:
                return $scope.error_register = 'Error de acceso';
            }
          } else {
            return $scope.error_register = 'Error de acceso';
          }
        });
      }
    };
    $scope.$watchCollection('register', function(fin, ini) {
      $scope.error_register = false;
      $scope.checkin = {
        status: false,
        value: false
      };
      if (typeof fin !== 'undefined') {
        console.log($scope);
        if (fin.password && fin.repeat) {
          $scope.register_form.register_repeat.$setValidity("unmatch", fin.password === fin.repeat);
        } else {
          $scope.register_form.register_repeat.$setValidity("unmatch", true);
        }
        if ((!fin.nickname) || (typeof ini !== 'undefined' && fin.nickname === ini.nickname)) {
          return false;
        }
        $scope.checkin = {
          status: true,
          value: false
        };
        return $account.available({
          username: fin.nickname
        }).then(function(res) {
          console.log(res);
          return $scope.checkin.value = "<i class=\"fa fa-check txt-green\"></i>\n<span class=\"txt-green txt-sbold small\">Este nombre de usuario está disponible</span>";
        }, function(err) {
          console.error(err);
          return $scope.checkin.value = "<i class=\"fa fa-times txt-red\"></i>\n<span class=\"txt-red txt-sbold small\">Este nombre de usuario ya está en uso</span>";
        });
      }
    });
    return $scope.password_recover = function() {
      if (!$scope.login || !$scope.login.username) {
        $scope.recover_ok = null;
        return $scope.error_login = 'Escribe tu nombre de usuario o tu email';
      }
      return $account.recover({
        username: $scope.login.username
      }).then(function(res) {
        console.log(res);
        $scope.recover_ok = 'Se ha enviado un email con las instrucciones al correo asociado a esta cuenta.';
        return $scope.error_login = null;
      }, function(err) {
        console.error(err);
        if (err.data.id) {
          switch (err.data.id) {
            case 1:
              return $scope.error_login = 'No hay cuentas registradas con estos datos.';
            default:
              return $scope.error_login = 'Error de acceso';
          }
        } else {
          return $scope.error_register = 'Error de acceso';
        }
      });
    };
  }
]);

tolerantApp.factory('$account', [
  '$resource', function($resource) {
    return {

      /*
      	 * Logueo de usuarios
      	 * @namespace $account
      	 * @restapi '/account/login'
      	 * @resterror {0/Backend error} Respuesta en caso de error inprevisto o sin identificar
      	 * @resterror {1/not exist} Respuesta en caso de que el usuario no exista
      	 * @param {Object} identification { username: username or email , password: password }
      	 * @return {null} reload
       */
      login: function(data) {
        return $resource('/account/login').save(data).$promise;
      },

      /*
      	 * DesLogueo de usuarios	
      	 * @namespace $account
      	 * @restapi '/account/logout'
      	 * @param {null} 
      	 * @return {null} reload
       */
      logout: function(data) {
        return $resource('/account/logout').get().$promise;
      },

      /*
      	 * Registro de usuarios
      	 * @namespace $account
      	 * @restapi '/account/register'
      	 * @param {Object} register { username: username, email: email , password: password }
      	 * @return {Boolean} reload
       */
      register: function(data) {
        return $resource('/account/register').save(data).$promise;
      },

      /*
      	 * Comprueba la disponibilidad de nombre y email
      	 * @namespace $account
      	 * @restapi '/account/available'
      	 * @param {Object} available { name: nombre, email: email }
      	 * @return {Boolean} available or not
       */
      available: function(data) {
        return $resource('/account/available').save(data).$promise;
      },
      recover: function(data) {
        return $resource('/account/recover').save(data).$promise;
      }
    };
  }
]);

tolerantApp.factory('$items', [
  '$resource', function($resource) {
    return {

      /*
      	 * Petición de todos los items: productos, lugares y afecciones
      	 * @namespace $items
      	 * @restapi '/find/all'
      	 * @param {null}
      	 * @return {Array} Lista de todos los elementos ordenados por número de visitas
       */
      get_all: function(data) {
        return $resource('/elements/all');
      },

      /*
      	 * Petición de todos los items: productos, lugares y afecciones
      	 * @namespace $items
      	 * @restapi '/product/all'
      	 * @param {null}
      	 * @return {Array} Lista de todos los productos ordenados por número de visitas
       */
      product_all: function(data) {
        return $resource('/producto/all').get().$promise;
      },

      /*
      	 * Petición de coemntarios
      	 * @namespace $items
      	 * @restapi '/product/comment'
      	 * @param {Object} 
      	 * @return {Array} Lista de todos los comentarios de ese producto
       */
      product_comment_get: function(data) {
        return $resource('/producto/comment/' + data).get().$promise;
      },

      /*
      	 * Envío de coemntarios
      	 * @namespace $items
      	 * @restapi '/product/comment'
      	 * @param {Object} 
      	 * @return {Array} Lista de todos los comentarios de ese producto
       */
      product_comment_post: function(data) {
        return $resource('/producto/comment').save(data).$promise;
      }
    };
  }
]);

tolerantApp.factory('$user', [
  '$resource', function($resource) {
    return {

      /*
      	 * Petición de todos los items: productos, lugares y afecciones
      	 * @namespace $items
      	 * @restapi '/find/all'
      	 * @param {null}
      	 * @return {Array} Lista de todos los elementos ordenados por número de visitas
       */
      save_fav: function(data) {
        return $resource('/users/:id/save_fav', {
          id: '@id'
        }, data);
      }
    };
  }
]);

tolerantApp.factory('$shared', function() {
  return {
    finder: ''
  };
});
