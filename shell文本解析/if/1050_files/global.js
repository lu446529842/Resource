$(function() {
	$("#wrap a, #wrap img").each(function(b) {
		if (this.title) {
			var c = this.title;
			var a = 30;
			$(this).mouseover(function(d) {
				this.title = "";
				$("body").append('<div id="tooltip">' + c + "</div>");
				$("#tooltip").css({
					left: (d.pageX + a) + "px",
					top: d.pageY + "px",
					opacity: "0.8"
				}).fadeIn(250)
			}).mouseout(function() {
				this.title = c;
				$("#tooltip").remove()
			}).mousemove(function(d) {
				$("#tooltip").css({
					left: (d.pageX + a) + "px",
					top: d.pageY + "px"
				})
			})
		}
	})
});
$('#comment-smiley').click(function() {
	$('#smileys').toggle();
});

$('#smileys a').click(function() {
	$(this).parent().parent().hide();
});
$(function() {
	$('#content h2 a').click(function(e) {
		e.preventDefault();
		var htm = '假装异步加载ing',
		i = 9,
		t = $(this).html(htm).unbind('click'); (function ct() {
			i < 0 ? (i = 9, t.html(htm), ct()) : (t[0].innerHTML += '.', i--, setTimeout(ct, 200))
		})();
		window.location = this.href
	})
});
$(".link-back2top").hide();
$(window).scroll(function() {
	if ($(this).scrollTop() > 100) {
		$(".link-back2top").fadeIn();
	} else {
		$(".link-back2top").fadeOut();
	}
});
$(".link-back2top a").click(function() {
	$("body,html").animate({
		scrollTop: 0
	},
	800);
	return false;
});
$(document).on('click', '.pingpart',
function() {
	$(this).css({
		color: "#b3b3b3"
	});
	$(".commentshow").hide(400);
	$(".pingtlist").show(400);
	$(".commentpart").css({
		color: "#A0A0A0"
	})
});
$(document).on('click', '.commentpart',
function() {
	$(this).css({
		color: "#b3b3b3"
	});
	$(".pingtlist").hide(400);
	$(".commentshow").show(400);
	$(".pingpart").css({
		color: "#A0A0A0"
	})
});
$body = (window.opera) ? (document.compatMode == "CSS1Compat" ? $('html') : $('body')) : $('html,body');
$(document).on('click', '.commentnav a', function(e){
	e.preventDefault();
	$.ajax({
		type: "GET",
		url: $(this).attr('href'),
		beforeSend: function() {
			$('.commentnav').remove();
			$('.commentlist').remove();
			$('#loading-comments').slideDown();
		},
		dataType: "html",
		success: function(out) {
			result = $(out).find('.commentlist');
			nextlink = $(out).find('.commentnav');
			$('#loading-comments').slideUp(500);
			$('#loading-comments').after(result.fadeIn(800));
			$(".reply").ajaxReply();
			$('.commentlist').after(nextlink);
		}
	});
})

jQuery.fn.ajaxReply = function() {
	$(this).click( //@ + username
	function() {
		var atname = $(this).parent().parent().find('.name').text();
		$("#comment").attr("value", "@" + atname).focus();
	});
	$('.cancel_comment_reply a').click(function() {
		$("#comment").attr("value", '');
	});
};
$(".reply").ajaxReply();

jQuery(document).ready(function($) {

	function addEditor(a, b, c) {
		if (document.selection) {
			a.focus();
			sel = document.selection.createRange();
			c ? sel.text = b + sel.text + c: sel.text = b;
			a.focus()
		} else if (a.selectionStart || a.selectionStart == '0') {
			var d = a.selectionStart;
			var e = a.selectionEnd;
			var f = e;
			c ? a.value = a.value.substring(0, d) + b + a.value.substring(d, e) + c + a.value.substring(e, a.value.length) : a.value = a.value.substring(0, d) + b + a.value.substring(e, a.value.length);
			c ? f += b.length + c.length: f += b.length - e + d;
			if (d == e && c) f -= c.length;
			a.focus();
			a.selectionStart = f;
			a.selectionEnd = f
		} else {
			a.value += b + c;
			a.focus()
		}
	}
	var g = document.getElementById('comment') || 0;
	var h = {
		strong: function() {
			addEditor(g, '<strong>', '</strong>')
		},
		em: function() {
			addEditor(g, '<em>', '</em>')
		},
		del: function() {
			addEditor(g, '<del>', '</del>')
		},
		underline: function() {
			addEditor(g, '<u>', '</u>')
		},
		quote: function() {
			addEditor(g, '<blockquote>', '</blockquote>')
		},
		ahref: function() {
			var a = prompt('请输入链接地址', 'http://');
			var b = prompt('请输入链接描述', '');
			if (a) {
				addEditor(g, '<a target="_blank" href="' + a + '"rel="external">' + b + '</a>', '')
			}
		},
		img: function() {
			var a = prompt('请输入图片地址', 'http://');
			if (a) {
				addEditor(g, '<img src="' + a + '" alt="" />', '')
			}
		},
		code: function() {
			addEditor(g, '<code>', '</code>')
		}
	};
	window['SIMPALED'] = {};
	window['SIMPALED']['Editor'] = h

});
$(".link-back2top").hover(

function() {　　$(".baby").stop().animate({
		'width': '128',
		'height': '128'
	},
	250);

},
function() {

	$(".baby").stop().animate({
		'width': '0',
		'height': '0'
	},
	250);

});
$(".wall li").hover(
function() {
	$(this).find('.lihide').show();
},
function() {
	$(this).find('.lihide').hide();
});
$('.showsearch').click(function() {
	$('#searchbox').toggle(400);
});