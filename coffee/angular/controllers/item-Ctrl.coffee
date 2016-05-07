
tolerantApp.controller('item-Ctrl', ['$scope', '$filter', '$timeout', '$user', '$items', ($scope, $filter, $timeout, $user, $items)->

	# console.log $scope
	
	iteartor = 5
	$scope.limited = iteartor
	$scope.see_comment = ->
		$scope.limited = $scope.limited + iteartor
	
	$scope.get_comment = ->
		if $scope.clase is 'producto'
			$items.product_comment_get($scope.ident).then( 
														(res)-> $scope.comments = $filter('orderBy')(res.comentarios, 'created', true)
													,
														(error)-> console.error error
													)
	
	$scope.post_comment = ->
		if $scope.clase is 'producto'
			$items.product_comment_post($scope.comment).then(
								(res)-> 
										console.log res
										$scope.product_comment.$setPristine()
										$scope.comment = null
										$scope.get_comment()
							,
								(err)-> console.error err
							)

	$timeout( $scope.get_comment ,1)


	$fav = angular.element('#fav').find('i')
	$scope.save_fav = (id, data)->
		console.log id, data, $scope.clase
		$user.save_fav().save({id: id}, {item:data, clase: $scope.clase}).$promise.then(
							(res)->
									console.log res
									if res.option is "removed" then return $fav.removeClass('fa-star').addClass('fa-star-o')
									if res.option is "added" then return $fav.removeClass('fa-star-o').addClass('fa-star')
						,
							(err)-> console.error err
						)

])