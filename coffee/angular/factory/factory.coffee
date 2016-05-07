
tolerantApp.factory('$account', ['$resource', ($resource)->
	###
	# Logueo de usuarios
	# @namespace $account
	# @restapi '/account/login'
	# @resterror {0/Backend error} Respuesta en caso de error inprevisto o sin identificar
	# @resterror {1/not exist} Respuesta en caso de que el usuario no exista
	# @param {Object} identification { username: username or email , password: password }
	# @return {null} reload
	###
	login: (data)->	$resource('/account/login').save(data).$promise
	
	###
	# DesLogueo de usuarios	
	# @namespace $account
	# @restapi '/account/logout'
	# @param {null} 
	# @return {null} reload
	###
	logout: (data)->	$resource('/account/logout').get().$promise

	###
	# Registro de usuarios
	# @namespace $account
	# @restapi '/account/register'
	# @param {Object} register { username: username, email: email , password: password }
	# @return {Boolean} reload
	###
	register: (data)->	$resource('/account/register').save(data).$promise

	# info -> Comprueba la disponibilidad de nombre y email
	# data -> Objeto: nombre, email	
	###
	# Comprueba la disponibilidad de nombre y email
	# @namespace $account
	# @restapi '/account/available'
	# @param {Object} available { name: nombre, email: email }
	# @return {Boolean} available or not
	###
	available: (data)->	$resource('/account/available').save(data).$promise

	# info -> Comprueba la disponibilidad de nombre y email
	# data -> Objeto: nombre, email
	recover: (data)->	$resource('/account/recover').save(data).$promise

])


tolerantApp.factory('$items', ['$resource', ($resource)->
	
	###
	# Petición de todos los items: productos, lugares y afecciones
	# @namespace $items
	# @restapi '/find/all'
	# @param {null}
	# @return {Array} Lista de todos los elementos ordenados por número de visitas
	###
	get_all: (data)->	$resource('/elements/all')
	
	###
	# Petición de todos los items: productos, lugares y afecciones
	# @namespace $items
	# @restapi '/product/all'
	# @param {null}
	# @return {Array} Lista de todos los productos ordenados por número de visitas
	###
	product_all: (data)->	$resource('/producto/all').get().$promise

	###
	# Petición de coemntarios
	# @namespace $items
	# @restapi '/product/comment'
	# @param {Object} 
	# @return {Array} Lista de todos los comentarios de ese producto
	###
	product_comment_get: (data)->	$resource('/producto/comment/' + data).get().$promise
	
	###
	# Envío de coemntarios
	# @namespace $items
	# @restapi '/product/comment'
	# @param {Object} 
	# @return {Array} Lista de todos los comentarios de ese producto
	###
	product_comment_post: (data)->	$resource('/producto/comment').save(data).$promise

	# info -> Registro de usuarios
	# data -> Objeto: nombre, email y contraseña
	# register: (data)->	$resource('/account/register').save(data).$promise

	# info -> Comprueba la disponibilidad de nombre y email
	# data -> Objeto: nombre, email
	# available: (data)->	$resource('/account/available').save(data).$promise

	# info -> Comprueba la disponibilidad de nombre y email
	# data -> Objeto: nombre, email
	# recover: (data)->	$resource('/account/recover').save(data).$promise

])

tolerantApp.factory('$user', ['$resource', ($resource)->
	
	###
	# Petición de todos los items: productos, lugares y afecciones
	# @namespace $items
	# @restapi '/find/all'
	# @param {null}
	# @return {Array} Lista de todos los elementos ordenados por número de visitas
	###
	save_fav: (data)-> $resource('/users/:id/save_fav', {id:'@id'}, data )

])

tolerantApp.factory('$shared', ->
    return {finder: ''}
)