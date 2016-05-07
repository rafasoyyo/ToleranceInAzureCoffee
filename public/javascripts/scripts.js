$(document).ready(function() {
  var $body, $formT, $head, $ini, $ini_top, $win, responsive;
  $body = $('body');
  $win = $(window);
  $head = $('header');
  if ($body.hasClass('Home')) {
    $ini = $('form#search');
  }
  if ($body.hasClass('Produto') || $body.hasClass('Lugar') || $body.hasClass('Produto')) {
    $ini = $('#item-header .item-info');
  }
  console.log($ini);
  if ($ini && $ini.length > 0) {
    $ini_top = $ini.offset().top - 10;
  }
  responsive = function() {
    if ($win.width() > 600) {
      $win.on('scroll', function(e) {
        if (($win.scrollTop() - $ini_top) > 0) {
          return $head.addClass('mobile');
        } else {
          return $head.removeClass('mobile');
        }
      });
      return $head.find('input').addClass('input-lg').end().find('button').addClass('btn-lg');
    } else {
      $win.off('scroll');
      return $head.addClass('mobile').find('input').removeClass('input-lg').end().find('button').removeClass('btn-lg');
    }
  };
  responsive();
  $win.resize(responsive);
  $formT = $('.form-tolerance');
  if ($formT.length > 0) {
    return $formT.find('input, textarea').each(function() {
      if ($(this).val().length) {
        return $(this).addClass('filled');
      } else {
        return $(this).removeClass('filled');
      }
    }).blur(function() {
      console.log('$(@).val().length' + $(this).val().length);
      if ($(this).val().length) {
        return $(this).addClass('filled');
      } else {
        return $(this).removeClass('filled');
      }
    });
  }
});
