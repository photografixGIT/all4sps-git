//jQuery dropdown menu with css fallback v1.3
//Author: Simon Battersby, www.simonbattersby.com
//Plugin page http://www.simonbattersby.com/blog/jquery-dropdown-menu-plugin-with-css-fallback/

//Usage: $('#mymenu').orangemenu([duration],[effect]});
//Example: $('#mymenu').orangemenu({duration: 'slow',effect: 'slide'});

(function($) {
$.fn.orangemenu = function(options) {
    $(this).data($.extend($.fn.orangemenu.defaults,options));
	
	return this.each(function() {
		$(this).find('li').hover(
			  function () {
				$(this).children('ul').stop(true,true);
			  	switch(options.effect){
				case('fade'):$(this).children('ul').show().css({opacity:0}).animate({opacity:1},options.duration);break;
				case('slide'):$(this).children('ul').slideDown(options.duration);break;
				case('show'):$(this).children('ul').show();break;
				case('diagonal'):$(this).children('ul').animate({width:'show',height:'show'},options.duration);break;
				case('left'):$(this).children('ul').animate({width:'show'},options.duration);break;
				case('slidefade'):$(this).children('ul').animate({height:'show',opacity:1});break
				case('diagonalfade'):$(this).children('ul').animate({width:'show',height:'show',opacity:1},options.duration);break;
				default:$(this).children('ul').fadeIn(options.duration);
				}
			  },
			  function () {
			  	switch(options.effect){
				case('fade'):$(this).children('ul').fadeOut(options.duration);break;
				case('slide'):$(this).children('ul').slideUp(options.duration);break;
				case('show'):$(this).children('ul').hide();break;
				case('diagonal'):$(this).children('ul').animate({width:'hide',height:'hide'},options.duration);break;
				case('left'):$(this).children('ul').animate({width:'hide'},options.duration);break;
				case('slidefade'):$(this).children('ul').animate({height:'hide',opacity:0},options.duration);break
				case('diagonalfade'):$(this).children('ul').animate({width:'hide',height:'hide',opacity:0},options.duration);break;
				default:$(this).children('ul').fadeOut(options.duration);
				}
			  }
		);
		$(this).find('ul').show().hide();//fire the show and hide to prevent the default css behaviour
	});
}
$.fn.orangemenu.defaults = {
duration: 'slow',
effect: 'fade'
};
})(jQuery);
