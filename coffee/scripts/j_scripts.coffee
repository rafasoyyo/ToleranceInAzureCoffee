
$(document).ready(->

	$body = $('body')
	$win  = $(window)
	$head = $('header')
	
	if $body.hasClass('Home')
		$ini = $('form#search')

		# finder = ->
		# 	$.post('/find', {search: $ini.find('input').val()} , (err, res)->
		# 		if err then return console.error err 
		# 		console.log res
		# 	)	
		
		# $ini
		# 	.find('input')
		# 		.blur( finder )
		# 	.end()
		# 	.find('button')
		# 		.click( finder )


	if $body.hasClass('Produto') or $body.hasClass('Lugar') or $body.hasClass('Produto')
		$ini = $('#item-header .item-info')


	console.log $ini
	if $ini and $ini.length > 0
		$ini_top = $ini.offset().top - 10


	responsive = ->
		if $win.width() > 600
			$win.on('scroll', (e)->
				if ($win.scrollTop() - $ini_top) > 0 then $head.addClass('mobile') else $head.removeClass('mobile')
			)

			$head
				.find('input').addClass('input-lg')
				.end()
				.find('button').addClass('btn-lg')

		else
			$win.off('scroll');
			$head
				.addClass('mobile')
				.find('input').removeClass('input-lg')
				.end()
				.find('button').removeClass('btn-lg')

	responsive()
	$win.resize(responsive)


	$formT = $('.form-tolerance')
	if $formT.length > 0
		$formT.find('input, textarea')
			.each ->
				if $(@).val().length then $(@).addClass('filled') else $(@).removeClass('filled')
			.blur ->
				console.log '$(@).val().length' + $(@).val().length
				if $(@).val().length then $(@).addClass('filled') else $(@).removeClass('filled')
)