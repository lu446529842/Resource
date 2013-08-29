/**
 * @author Chine
 */

 function switchTheme(theme) {
 	$.cookie('blog_theme', theme, { expires: 30, path: '/' });
	location.href = location.href;
 }
